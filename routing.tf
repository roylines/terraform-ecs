resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.vpc.name}-internet-gateway"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.vpc.name}-main-route-table"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_subnet" "main-1a" {
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.11.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.vpc.name}-1a-subnet"
  }
}

resource "aws_subnet" "main-1b" {
  availability_zone = "us-east-1b"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.12.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc.name}-1b-subnet"
  }
}

resource "aws_subnet" "main-1d" {
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.13.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc.name}-1d-subnet"
  }
}

resource "aws_subnet" "main-1e" {
  availability_zone = "us-east-1e"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.14.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.vpc.name}-1e-subnet"
  }
}
/*
resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.vpc.id}"
    egress {
        protocol = "tcp"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 80
        to_port = 80
    }

    ingress {
        protocol = "tcp"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 22
        to_port = 22
    }
    subnet_ids = ["${aws_subnet.main-1a.id}", "${aws_subnet.main-1b.id}", "${aws_subnet.main-1d.id}", "${aws_subnet.main-1e.id}"]
    tags {
      Name = "${var.vpc.name}-network-acl"
    }
}
*/
