resource "aws_key_pair" "instance" {
  key_name = "${var.vpc}-instance-key"
  public_key = "${var.ssh_public_key}"
}
