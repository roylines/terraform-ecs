vpc = "vpcname"
domain_name = "mydomain.com"
zone_id = "ZQRDDEIIIIIFIIR"

// microservices
microservices_count = 2

microservices_name.0 = "microservice-0"
microservices_image.0 = "roylines/nginx"
microservices_subdomain.0 = "micro-0"
microservices_desired_count.0 = 2

microservices_name.1 = "microservice-1"
microservices_image.1 = "roylines/nginx"
microservices_subdomain.1 = "micro-1"
microservices_desired_count.1 = 2
