/* see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html */
resource "aws_iam_role" "instance_role" {
    name = "${var.vpc}-instance-role"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "s3_read_only" {
    name = "s3-read-only"
    roles = ["${aws_iam_role.instance_role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "${var.vpc}-instance-profile"
    roles = ["${aws_iam_role.instance_role.name}"]
}

resource "aws_iam_role_policy" "instance_policy" {
  name = "${var.vpc}-instance-role-policy"
  role     = "${aws_iam_role.instance_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
