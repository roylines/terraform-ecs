resource "aws_security_group" "microservices_elb" {
  name = "${var.vpc}-microservices-elb"
  description = "security group used by all microservices elbs"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = 80 
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 8001
      to_port = 9001
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.vpc}-microservices-elb"
  }
}

resource "aws_security_group" "microservices" {
  name = "${var.vpc}-microservices"
  description = "security group used by clustered instances to allow microservices"
  vpc_id = "${aws_vpc.vpc.id}" 
  depends_on = ["aws_security_group.microservices_elb"]
  ingress {
      from_port = 8001
      to_port = 9001
      protocol = "tcp"
      security_groups = ["${aws_security_group.microservices_elb.id}"]
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

