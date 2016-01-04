output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.cluster.id}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.server_role.arn}"
}

output "subnet_ids" {
  value = "${aws_subnet.main-1a.id},${aws_subnet.main-1b.id},${aws_subnet.main-1d.id},${aws_subnet.main-1e.id}"
}
