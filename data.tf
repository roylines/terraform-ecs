data "template_file" "ecs_config" {
  template = "${file("${path.module}/data/ecs-config.txt")}"
  vars {
    cluster = "${aws_ecs_cluster.cluster.name}"
  }
}

data "template_file" "awslogs_conf" {
  template = "${file("${path.module}/data/awslogs.conf")}"
  vars {
    log_group_name = "${aws_cloudwatch_log_group.cluster.name}"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/data/user-data.sh")}"
  vars {
    ecs_config_path = "${aws_s3_bucket.config.id}/${aws_s3_bucket_object.ecs_config.key}"
    awslogs_conf_path = "${aws_s3_bucket.config.id}/${aws_s3_bucket_object.awslogs_conf.key}"
  }
}

data "template_file" "user_data_bootstrap" {
  template = "${file("${path.module}/data/user-data-bootstrap.sh")}"
  vars {
    user_data_path = "${aws_s3_bucket.config.id}/${aws_s3_bucket_object.user_data.key}"
  }
}
