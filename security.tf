resource "aws_key_pair" "instance" {
  key_name = "${local.namespace}-instance-key"
  public_key = "${var.ssh_public_key}"
}

resource "aws_iam_role" "role" {
  name = "${local.namespace}-role"
  assume_role_policy = "${file("${path.module}/data/ecs-role.json")}"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${local.namespace}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy" "policy" {
  name = "${local.namespace}-policy"
  role = "${aws_iam_role.role.id}"
  policy = "${file("${path.module}/data/ecs-policy.json")}"
}

resource "aws_iam_policy_attachment" "s3_read_only" {
  name = "s3-read-only"
  roles = ["${aws_iam_role.role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_security_group" "cluster" {
  name = "${local.namespace}-cluster"
  description = "security group used by clustered instances"
  vpc_id = "${aws_vpc.vpc.id}" 
  /*
  ingress {
      from_port = 22 
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  */
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${local.namespace}-cluster"
  }
}

