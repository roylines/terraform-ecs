resource "aws_ecs_cluster" "cluster" {
  name = "${var.vpc}-cluster"
}

resource "aws_security_group" "cluster" {
  name = "${var.vpc}-cluster"
  description = "security group used by clustered instances"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = 22 
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.vpc}-cluster"
  }
}

resource "aws_autoscaling_group" "cluster" {
  name = "${var.vpc}-auto-scaling-group"
  max_size = "${var.cluster_max}"
  min_size = "${var.cluster_min}"
  desired_capacity = "${var.cluster_desired_size}"
  launch_configuration = "${aws_launch_configuration.cluster.name}"
  vpc_zone_identifier = ["${split(",", join(",", aws_subnet.public.*.id))}"]
  tag {
    key = "Name"
    value = "${var.vpc}-cluster-instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "cluster" {
    name_prefix = "${var.vpc}-cluster"
    image_id = "${var.image_id}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"
    security_groups = ["${aws_security_group.cluster.id}", "${aws_security_group.microservices.id}"]
    key_name = "${aws_key_pair.instance.key_name}"
    depends_on = ["aws_s3_bucket_object.ecs_config", "aws_s3_bucket_object.awslogs_conf"]
    user_data = <<EOF
#!/bin/bash
yum -y update --security
yum install -y aws-cli awslogs jq

# copy configurations
aws s3 cp s3://${aws_s3_bucket.ecs_config.id}/ecs.config /etc/ecs/ecs.config
aws s3 cp s3://${aws_s3_bucket.ecs_config.id}/awslogs.conf /etc/awslogs/awslogs.conf

# substitute container id 
sed -i -e "s/{container_instance_id}/$HOSTNAME/g" /etc/awslogs/awslogs.conf

# substitute region 
region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

# start aws logs 
service awslogs start
chkconfig awslogs on
EOF
}
