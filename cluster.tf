resource "aws_ecs_cluster" "cluster" {
  name = "${var.vpc}-cluster"
}

resource "aws_security_group" "cluster" {
  name = "${var.vpc}-cluster"
  description = "security group used by clustered instances"
  vpc_id = "${aws_vpc.vpc.id}" 
  /* to do - use bastion here */
  ingress {
      from_port = 22 
      to_port = 22
      protocol = "TCP"
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
  lifecycle {
    create_before_destroy = true
  }
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
    security_groups = ["${aws_security_group.cluster.id}", "${aws_security_group.api_gateway_cluster.id}", "${aws_security_group.microservices.id}"]
    key_name = "${aws_key_pair.instance.key_name}"
    lifecycle {
      create_before_destroy = true
    }
    user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
}
