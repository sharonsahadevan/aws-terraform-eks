
variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "vpc-stg"
}


# variable "gateway_id" {}

# variable "vpc_id" {}

# variable "subnet_id" {}



variable "cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}


# variable "tags"{
#   default = {
#     Organization  = "redseal"
#     Application   = "ctp"
#     Owner         = "terraform"
#     Stack         = "stg"
#     Name          = "vpc-stg"
#   }
# }




#variable "environment" {}
#variable "app_name" {}
#variable "cidr" {}
#variable "public_subnets" {}
#variable "private_subnets" {}
variable "name"{}
variable "enable_s3_endpoint" {}
variable "enable_dns_hostnames" {}
variable "enable_nat_gateway" {}
variable "single_nat_gateway" {}
variable "one_nat_gateway_per_az"{}
variable "tags"{}
variable "public_subnet_tags"{}
variable "private_subnet_tags" {}
