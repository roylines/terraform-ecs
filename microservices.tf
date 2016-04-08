resource "aws_security_group" "microservices" {
  name = "${var.vpc}-microservices"
  description = "security group used by clustered instances to allow microservices"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = "${var.from_port}" 
      to_port = "${var.to_port}"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.vpc}-microservices"
  }
}

resource "aws_route53_zone" "microservices" {
  name = "${var.vpc}-private"
  comment = "HostedZone for microservices within ${var.vpc}" 
  vpc_id = "${aws_vpc.vpc.id}" 
  tags {
    Name = "${var.vpc}-private"
  }
}

