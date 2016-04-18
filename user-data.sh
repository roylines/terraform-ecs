#!/bin/bash
yum -y update
yum install -y aws-cli awslogs jq

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
if ["${newrelic_license_key}" = "none" ]; then
  echo "no newrelic key set, skipping"
else
  rpm -Uvh https://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
  yum install -y newrelic-sysmond
  nrsysmond-config --set license_key=${newrelic_license_key}
  echo "labels=Type:cluster;VPC:${vpc};Instance:$instanceId" >> /etc/newrelic/nrsysmond.cfg

  /etc/init.d/newrelic-sysmond start
fi
