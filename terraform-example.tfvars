vpc = "vpcname"
domain_name = "mydomain.com"
zone_id = "ZQRDDEIIIIIFIIR"

// api gateway
api_gateway_image = "roylines/terraform-ecs-api-gateway"
api_gateway_desired_count = 2

// microservices
microservices_count = 2

microservices_name.0 = "microservice-0"
microservices_image.0 = "roylines/nginx"
microservices_memory.0 = 50 
microservices_cpu.0 = 10 
microservices_port.0 = 80
microservices_desired_count.0 = 2

microservices_name.1 = "microservice-1"
microservices_image.1 = "roylines/nginx"
microservices_memory.1 = 50 
microservices_cpu.1 = 10 
microservices_port.1 = 80
microservices_desired_count.1 = 2


