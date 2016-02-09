resource "aws_security_group" "api_gateway_cluster" {
  name = "${var.vpc}-api-gateway-cluster"
  description = "security group used by clustered instances for api gateway"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = 8000 
      to_port = 8000
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.vpc}-api-gateway-cluster"
  }
}


resource "aws_security_group" "api_gateway_elb" {
  name = "${var.vpc}-api-gateway-elb"
  description = "security group used by elb for api gateway"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = 80 
      to_port = 80
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 8000
      to_port = 8000
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.vpc}-api-gateway-elb"
  }
}

resource "aws_elb" "api_gateway" {
  name = "${var.vpc}-api-gateway"
  subnets = ["${split(",", join(",", aws_subnet.public.*.id))}"]
  security_groups = ["${aws_security_group.api_gateway_elb.id}"]

  listener {
    instance_port = "8000"
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
    target = "HTTP:8000/"
    interval = 30
  }
  tags {
    Name = "${var.vpc}-api-gateway"
  }
}

resource "aws_route53_record" "api_gateway_www" {
  zone_id = "${var.zone_id}"
  name = "www.${var.domain_name}"
  type = "A"

  alias {
    name = "${aws_elb.api_gateway.dns_name}"
    zone_id = "${aws_elb.api_gateway.zone_id}"
    evaluate_target_health = false 
  }
}

resource "aws_route53_record" "api_gateway" {
  zone_id = "${var.zone_id}"
  name = "${var.domain_name}"
  type = "A"

  alias {
    name = "${aws_elb.api_gateway.dns_name}"
    zone_id = "${aws_elb.api_gateway.zone_id}"
    evaluate_target_health = false 
  }
}

resource "aws_ecs_task_definition" "api_gateway" {
  family = "${var.vpc}-api-gateway"
  container_definitions = <<EOF
[
  {
    "name": "${var.vpc}-api-gateway",
    "image": "${var.api_gateway_image}",
    "cpu": 10,
    "memory": 50,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 8000
      }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "api_gateway" {
  name = "${var.vpc}-api-gateway"
  cluster = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.api_gateway.arn}"
  desired_count = "${var.api_gateway_desired_count}"
  iam_role = "${aws_iam_role.server_role.arn}"
  depends_on = ["aws_iam_role_policy.server_policy"]

  load_balancer {
    elb_name = "${aws_elb.api_gateway.id}"
    container_name = "${var.vpc}-api-gateway"
    container_port = 80
  }
}
