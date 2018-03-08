#!/bin/bash
set -e

# minimal bootstrap to initiate user data
yum -y update
yum install -y aws-cli

# minimal bootstrap to initiate user data
aws s3 cp s3://${user_data_path} /usr/local/src/userdata.sh
chmod u+x /usr/local/src/userdata.sh
/usr/local/src/userdata.sh
