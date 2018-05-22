variable "region" {
  description = "the region"
  default = "us-east-1"
}

variable "environment" {
  description = "the environment"
  default = "prod"
}

variable "name" {
  description = "the name of this cluster"
  default = "ecs"
}

variable "ssh_public_key" {
  description = "public key to allow ssh to cluster instances"
}

variable "asg_names" {
  default = ["a", "b"]
}

variable "asg_sizes" {
  description = "Minimum cluster size"
  default = [2, 0]
}

variable "asg_instance_types" {
  description = "The EC2 instance type for ECS container instances"
  default = ["t2.nano", "t2.nano"]
}

variable "asg_image_ids" {
  description = "The AMI to use for ECS container instances, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html"
  default = ["ami-a7a242da", "ami-a7a242da"]
}

locals {
  namespace = "${var.environment}-${var.name}"
}

