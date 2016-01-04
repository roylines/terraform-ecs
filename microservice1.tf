resource "aws_elb" "micro_1" {
  name = "${var.vpc}-micro-1"
  subnets = ["${aws_subnet.main-1a.id}", "${aws_subnet.main-1b.id}","${aws_subnet.main-1d.id}","${aws_subnet.main-1e.id}"]
  security_groups = ["${aws_security_group.cluster.id}"]

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8080/"
    interval = 30
  }

  tags {
    Name = "${var.vpc}-micro-1"
  }
}

resource "aws_route53_record" "micro_1" {
  zone_id = "${var.zone_id}"
  name = "${var.vpc}-micro-1.${var.domain_name}"
  type = "A"

  alias {
    name = "${aws_elb.micro_1.dns_name}"
    zone_id = "${aws_elb.micro_1.zone_id}"
    evaluate_target_health =false 
  }
}

resource "aws_ecs_task_definition" "micro_1" {
  family = "${var.vpc}-micro-1"
  container_definitions = <<EOF
[
  {
    "name": "${var.vpc}-micro-1",
    "image": "roylines/docker-nginx",
    "cpu": 10,
    "memory": 50,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 8080
      }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "micro_1" {
  name = "${var.vpc}-micro-1"
  cluster = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.micro_1.arn}"
  desired_count = 2
  iam_role = "${aws_iam_role.server_role.arn}"
  depends_on = ["aws_iam_role_policy.server_policy"]

  load_balancer {
    elb_name = "${aws_elb.micro_1.id}"
    container_name = "${var.vpc}-micro-1"
    container_port = 80
  }
}
