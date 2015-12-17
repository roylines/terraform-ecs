resource "aws_security_group" "cluster" {
  name = "${var.vpc.name}-cluster-security-group"
  description = "security group used by clustered instances"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

