output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.cluster.id}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.server_role.arn}"
}

output "subnet_ids" {
  value = "${join(",", aws_subnet.sub.*.id)}"
}

output "microservices" {
  value = "${join(",", aws_route53_record.microservice.*.name)}"
}
