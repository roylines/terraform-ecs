resource "aws_key_pair" "instance" {
  key_name = "${var.vpc.name}-instance-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
