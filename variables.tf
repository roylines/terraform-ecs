variable "vpc" {
  description = "the vpc name"
  default = "tf-ecs"
}

variable "region" {
  description = "the region"
  default = "us-east-1"
}

variable "availability-zones" {
  description = "The availability-zones to create"
  default = "us-east-1a,us-east-1b,us-east-1d,us-east-1e"
}

variable "instance_type" {
  description = "The EC2 instance type for ECS container instances"
  default = "t2.nano"
}

variable "image_id" {
  description = "The AMI to use for ECS container instances"
  default = "ami-4fe4852a"
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

variable "ssh_public_key" {
  description = "public key to allow ssh to cluster instances"
}
