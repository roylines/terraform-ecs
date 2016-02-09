resource "aws_ecs_cluster" "cluster" {
  name = "${var.vpc}-cluster"
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
    name_prefix = "${var.vpc}-"
    image_id = "${var.image_id}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"
    security_groups = ["${aws_security_group.api_gateway_cluster.id}"]
    key_name = "${aws_key_pair.instance.key_name}"
    user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
}
