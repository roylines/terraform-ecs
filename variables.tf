variable "environment" {
  description = "the environment"
  default = "prod"
}

variable "name" {
  description = "the name of this cluster"
  default = "ecs"
}

variable "region" {
  description = "the region"
  default = "us-east-1"
}

variable "ssh_public_key" {
  description = "public key to allow ssh to cluster instances"
}

variable "cluster_min" {
  description = "Minimum cluster size"
  default = 2
}

variable "cluster_max" {
  description = "Maximum cluster size"
  default = 3
}

variable "cluster_desired_size" {
  description = "Desired cluster size"
  default = 2
}

variable "instance_type" {
  description = "The EC2 instance type for ECS container instances"
  default = "t2.nano"
}

variable "image_id" {
  description = "The AMI to use for ECS container instances, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html"
  default = "ami-a7a242da"
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

/*
variable "from_port" {
  description = "the ingress from port range"
  default = 8000
}

variable "to_port" {
  description = "the ingress to port range"
  default = 8010
}

variable "newrelic_license_key" {
  description = "new relic license key (only needed for newrelic support)"
  default = "none"
}

variable "ruxit_account" {
  description = "the ruxit account number (only needed for ruxit support)"
  default = "none"
}

variable "ruxit_token" {
  description = "the ruxit token (only needed for ruxit support)"
  default = "none"
}

variable "sysdig_access_key" {
  description = "the sysdig access key (only needed for sysdig support)"
  default = "none"
}

*/
