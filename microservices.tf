resource "aws_security_group" "microservices_elb" {
  count = "${var.microservices_count}"
  name = "${var.vpc}-${lookup(var.microservices_name, count.index)}-elb"
  description = "security group used by elb for ${lookup(var.microservices_name, count.index)}"
  vpc_id = "${aws_vpc.vpc.id}" 
  ingress {
      from_port = 80 
      to_port = 80
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = "${ count.index + 8001 }"
      to_port = "${ count.index + 8001 }"
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.vpc}-${lookup(var.microservices_name, count.index)}-elb"
  }
}

resource "aws_security_group" "microservices" {
  name = "${var.vpc}-microservices"
  description = "security group used by clustered instances to allow microservices"
  vpc_id = "${aws_vpc.vpc.id}" 
  depends_on = ["aws_security_group.microservices_elb"]
  ingress {
      from_port = 8001
      to_port = "${ var.microservices_count + 8000}"
      protocol = "TCP"
      security_groups = ["${aws_security_group.microservices_elb.*.id}"]
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

resource "aws_elb" "microservice" {
  count = "${var.microservices_count}"
  name = "${var.vpc}-${lookup(var.microservices_name, count.index)}"
  subnets = ["${split(",", join(",", aws_subnet.public.*.id))}"]
  security_groups = ["${element(aws_security_group.microservices_elb.*.id, count.index)}"]

  listener {
    instance_port = "${ count.index + 8001 }"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  
  internal = true
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:${ count.index + 8001 }/"
    interval = 30
  }
  tags {
    Name = "${var.vpc}-${lookup(var.microservices_name, count.index)}"
  }
}

resource "aws_ecs_task_definition" "microservice" {
  count = "${var.microservices_count}"
  family = "${var.vpc}-${lookup(var.microservices_name, count.index)}"
  container_definitions = <<EOF
[
  {
    "name": "${var.vpc}-${lookup(var.microservices_name, count.index)}",
    "image": "${lookup(var.microservices_image, count.index)}",
    "cpu": ${lookup(var.microservices_cpu, count.index)},
    "memory": ${lookup(var.microservices_memory, count.index)},
    "portMappings": [
      {
        "containerPort": ${lookup(var.microservices_port, count.index)},
        "hostPort": ${ count.index + 8001 }
      }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "microservice" {
  count = "${var.microservices_count}"
  name = "${var.vpc}-${lookup(var.microservices_name, count.index)}"
  cluster = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${element(aws_ecs_task_definition.microservice.*.arn, count.index)}"
  desired_count = "${lookup(var.microservices_desired_count, count.index)}"
  iam_role = "${aws_iam_role.server_role.arn}"
  depends_on = ["aws_iam_role_policy.server_policy"]

  load_balancer {
    elb_name = "${element(aws_elb.microservice.*.id, count.index)}"
    container_name = "${var.vpc}-${lookup(var.microservices_name, count.index)}"
    container_port = 80
  }
}
