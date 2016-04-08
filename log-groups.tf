resource "aws_cloudwatch_log_group" "cluster" {
  name = "${var.vpc}-cluster"
}

