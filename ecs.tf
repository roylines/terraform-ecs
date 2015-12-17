resource "aws_ecs_cluster" "cluster" {
  name = "${var.vpc.name}-cluster"
}
