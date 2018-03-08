resource "aws_s3_bucket" "config" {
  bucket = "${local.namespace}-ecs-config"
  acl = "private"

  tags {
    Name = "${local.namespace}-ecs-config"
  }
}

resource "aws_s3_bucket_object" "awslogs_conf" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "awslogs.conf"
  content = "${data.template_file.awslogs_conf.rendered}"
}

resource "aws_s3_bucket_object" "ecs_config" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "ecs.config"
  content = "${data.template_file.ecs_config.rendered}"
}

resource "aws_s3_bucket_object" "user_data" {
  bucket = "${aws_s3_bucket.config.id}"
  key = "userdata.sh"
  content = "${data.template_file.user_data.rendered}"
}
