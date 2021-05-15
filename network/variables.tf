
variable "region" {
  default = "us-east-1"
  type    = string
}

variable "stack" {
  type    = string
  default = "example"
}
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


variable "enable_dns_hostnames" {
  type = bool 
  description = "Should be true to enable DNS hostnames in the Default VPC"
  default = true 
}
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default = true
  type = bool
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default = false
  type = bool 

}
variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  default = false
  type = bool 
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
  default = {}
}
variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type = map(string)
  default = {}
}
variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  default = {}
  type = map(string)
}
