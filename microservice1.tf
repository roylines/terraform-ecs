resource "aws_elb" "micro_1" {
  name = "${var.vpc.name}-micro-1"
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

  tags {
    Name = "${var.vpc.name}-micro-1"
  }
}

resource "aws_route53_record" "micro_1" {
  zone_id = "${var.zone_id}"
  name = "${var.vpc.name}-micro-1.${var.domain_name}"
  type = "A"

  alias {
    name = "${aws_elb.micro_1.dns_name}"
    zone_id = "${aws_elb.micro_1.zone_id}"
    evaluate_target_health =false 
  }
}

/*
resource "aws_ecs_task_definition" "micro_1" {
  family = "jenkins"
  container_definitions = "${file("task-definitions/jenkins.json")}"

  volume {
    name = "jenkins-home"
    host_path = "/ecs/jenkins-home"
  }
}
*/
