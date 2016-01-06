resource "aws_security_group" "cluster" {
  name = "${var.vpc}-cluster"
  description = "security group used by clustered instances"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = 8000 
      to_port = "${ var.microservices_count + 7999}"
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.vpc}-cluster"
  }
}


