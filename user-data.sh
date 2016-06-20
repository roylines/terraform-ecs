#!/bin/bash
set -e

yum install -y aws-cli awslogs jq wget

# copy configurations
aws s3 cp s3://${bucket_id}/ecs.config /etc/ecs/ecs.config
aws s3 cp s3://${bucket_id}/awslogs.conf /etc/awslogs/awslogs.conf

# substitute container id 
instanceId=$(curl 169.254.169.254/latest/meta-data/instance-id)
sed -i -e "s/{container_instance_id}/$instanceId/g" /etc/awslogs/awslogs.conf

# substitute region 
region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

# start aws logs 
service awslogs start
chkconfig awslogs on

# configure and start new relic server monitoring 
if [ "${newrelic_license_key}" = "none" ]; then
  echo "no newrelic key set, skipping"
else
  echo "configuring newrelic"
  rpm -Uvh https://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
  yum install -y newrelic-sysmond
  nrsysmond-config --set license_key=${newrelic_license_key}
  echo "labels=Type:cluster;VPC:${vpc};Instance:$instanceId" >> /etc/newrelic/nrsysmond.cfg

  /etc/init.d/newrelic-sysmond start
fi

# configure and start ruxit monitoring 
if [ "${ruxit_account}" = "none" ]; then
  echo "no ruxit account set, skipping"
else
  echo "configuring ruxit"
  pushd /usr/local/src
  wget -O ruxit-agent-install.sh https://${ruxit_account}.live.ruxit.com/installer/agent/unix/latest/${ruxit_token}
  chmod u+x ./ruxit-agent-install.sh
  ./ruxit-agent-install.sh
  popd
fi

# configure and start sysdig monitoring (docker version not available in ECS) 
if [ "${sysdig_access_key}" = "none" ]; then
  echo "no sysdig key set, skipping"
else
  echo "configuring sysdig"
  pushd /usr/local/src
  wget -O sysdig-agent-install.sh https://s3.amazonaws.com/download.draios.com/stable/install-agent
  chmod u+x ./sysdig-agent-install.sh
  ./sysdig-agent-install.sh --access_key ${sysdig_access_key} --tags "instanceid:$instanceId" 
  popd
fi
