# terraform-ecs
A terraform module for creating an ECS cluster. 
This module can be used to create a new vpc complete with subnets, security groups and instances. 
There are many [variables](https://github.com/roylines/terraform-ecs/blob/master/variables.tf) that can be set to configure instance size and availability zones.

# Usage 
There is a full example of using this module within a microservices architecture [here](https://github.com/roylines/terraform-ecs-example) 

It is strongly recommended that you version your module sources. The latest stable version of this module is *v2.0.0*

The following minimal terraform templat example will create the cluster using the supplied ssh public key.

```
variable "ssh_public_key" {
  description = "the public key to allow ssh access to the clustered instances"
}

module "ecs" {
  source = "git::https://github.com/roylines/terraform-ecs?ref=v2.0.0" 
  ssh_public_key = "${var.ssh_public_key}"
}
```
