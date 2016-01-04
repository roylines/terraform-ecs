variable "vpc" {}

variable "domain_name" {}

variable "zone_id" {}

variable "region" {}

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
  default = 1
}

variable "cluster_max" {
  description = "Maximum cluster size"
  default = 2
}

variable "cluster_desired_size" {
  description = "Desired cluster size"
  default = 2
}
