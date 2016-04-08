resource "aws_s3_bucket" "ecs_config" {
    bucket = "${var.vpc}-ecs-config"
    acl = "private"

    tags {
        Name = "${var.vpc}-ecs-config"
    }
}

resource "aws_s3_bucket_object" "ecs_config" {
    bucket = "${aws_s3_bucket.ecs_config.id}"
    key = "ecs.config"
    content = <<EOF
ECS_CLUSTER=${aws_ecs_cluster.cluster.name}
EOF
}

resource "aws_s3_bucket_object" "awslogs_conf" {
    bucket = "${aws_s3_bucket.ecs_config.id}"
    key = "awslogs.conf"
    content = <<EOF
[general]
state_file = /var/lib/awslogs/agent-state        
 
[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${aws_cloudwatch_log_group.cluster.name}
log_stream_name = {container_instance_id}/var/log/dmesg

[/var/log/messages]
file = /var/log/messages
log_group_name = ${aws_cloudwatch_log_group.cluster.name}
log_stream_name = {container_instance_id}/var/log/messages
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = ${aws_cloudwatch_log_group.cluster.name}
log_stream_name = {container_instance_id}/var/log/docker
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log.*
log_group_name = ${aws_cloudwatch_log_group.cluster.name}
log_stream_name = {container_instance_id}/var/log/ecs-init.log
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = ${aws_cloudwatch_log_group.cluster.name}
log_stream_name = {container_instance_id}/var/log/ecs-agent.log
datetime_format = %Y-%m-%dT%H:%M:%SZ
EOF
}
