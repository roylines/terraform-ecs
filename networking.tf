resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${local.namespace}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${local.namespace}"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.public.id}"
}

data "aws_availability_zones" "available" {
}

resource "aws_subnet" "public" {
  count = "${length(data.aws_availability_zones.available.names)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.2${count.index}.0/24"
  map_public_ip_on_launch = true 
  tags {
    Name = "${local.namespace}-${count.index}"
  }
}

