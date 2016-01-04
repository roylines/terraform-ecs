/* see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/server_IAM_role.html */

resource "aws_iam_role" "server_role" {
    name = "${var.vpc}-server-role"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "server_policy" {
  name = "${var.vpc}-server-role-policy"
  role     = "${aws_iam_role.server_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
