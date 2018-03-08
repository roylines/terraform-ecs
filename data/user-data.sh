#!/bin/bash
set -e

yum install -y aws-cli awslogs jq wget

# copy configurations
aws s3 cp s3://${ecs_config_path} /etc/ecs/ecs.config
aws s3 cp s3://${awslogs_conf_path} /etc/awslogs/awslogs.conf

# substitute container id 
instanceId=$(curl 169.254.169.254/latest/meta-data/instance-id)
sed -i -e "s/{container_instance_id}/$instanceId/g" /etc/awslogs/awslogs.conf

# substitute region 
region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

# start aws logs 
service awslogs start
chkconfig awslogs on

# TODO configure monitoring ?
