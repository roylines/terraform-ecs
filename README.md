# terraform-ecs
Latest release: *v2.0.0*

A terraform module for creating an ECS cluster. There are several [variables](https://github.com/roylines/terraform-ecs/blob/master/variables.tf) that can be set to configure, for example,instance type and availability zones.

# Usage 
Instructions for using terraform modules can be found within the [Terraform documentation](https://www.terraform.io/docs/modules/usage.html)
It is strongly recommended that when using this module, you use versioned links to the repository.

The following minimal terraform template example will create the cluster using the supplied ssh public key.

```
variable "ssh_public_key" {
  description = "the public key to allow ssh access to the clustered instances"
}

module "ecs" {
  source = "git::https://github.com/roylines/terraform-ecs?ref=v2.0.0" 
  ssh_public_key = "${var.ssh_public_key}"
}
```

A more complex example can be found at [https://github.com/roylines/terraform-ecs-example](https://github.com/roylines/terraform-ecs-example) 
