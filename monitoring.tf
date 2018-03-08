resource "aws_cloudwatch_log_group" "cluster" {
  name = "${aws_ecs_cluster.cluster.name}"
}
