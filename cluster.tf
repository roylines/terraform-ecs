resource "aws_ecs_cluster" "cluster" {
  name = "${local.namespace}"
}

resource "aws_launch_configuration" "cluster" {
  count = "${length(var.asg_names)}"
  name_prefix = "${local.namespace}-${element(var.asg_names, count.index)}"
  image_id = "${element(var.asg_image_ids, count.index)}"
  instance_type = "${element(var.asg_instance_types, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  security_groups = ["${aws_security_group.cluster.id}"]
  key_name = "${aws_key_pair.instance.key_name}"
  user_data = "${data.template_file.user_data_bootstrap.rendered}"
}

resource "aws_autoscaling_group" "cluster" {
  count = "${length(var.asg_names)}"
  name = "${local.namespace}-${element(var.asg_names, count.index)}"
  max_size = "${element(var.asg_sizes, count.index)}"
  min_size = "${element(var.asg_sizes, count.index)}"
  desired_capacity = "${element(var.asg_sizes, count.index)}"
  launch_configuration = "${element(aws_launch_configuration.cluster.*.name, count.index)}"
  vpc_zone_identifier = ["${split(",", join(",", aws_subnet.public.*.id))}"]
  tag {
    key = "Name"
    value = "${local.namespace}-${element(var.asg_names, count.index)}"
    propagate_at_launch = true
  }
}
