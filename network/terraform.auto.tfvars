# VPC
private_subnets        = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
public_subnets         = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
cidr                   = "10.1.0.0/16"
enable_nat_gateway     = true
single_nat_gateway     = true
enable_dns_hostnames   = true
enable_s3_endpoint     = true
one_nat_gateway_per_az = true
