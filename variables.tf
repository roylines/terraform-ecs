variable "vpc" {
  description = "the desired vpc name"
}

variable "domain_name" {
  description = "the domain name to configure routing to in route 53"
}

variable "zone_id" {
  description = "the zone_id to use"
}

variable "region" {
  description = "the region"
  default = "us-east-1"
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
