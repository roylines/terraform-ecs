output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "cluster_id" {
  value = "${aws_ecs_cluster.cluster.id}"
}

output "private_zone_id" {
  value = "{aws_route53_zone.microservices.id}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.server_role.arn}"
}

output "subnets" {
 value = "${join(",", aws_subnet.public.*.id)}"
}

