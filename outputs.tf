output "cluster_name" {
  description = "the name of the cluster"  
  value = "${aws_ecs_cluster.cluster.name}"
}
