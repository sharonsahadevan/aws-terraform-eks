data "aws_availability_zones" "available" {}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "2.70.0"
  cidr                   = var.vpc_cidr
  name                   = "vpc-${var.stack}"
  azs                    = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  enable_s3_endpoint     = var.vpc_enable_s3_endpoint
  enable_dns_hostnames   = var.vpc_enable_dns_hostnames
  single_nat_gateway     = var.vpc_single_nat_gateway
  enable_nat_gateway     = var.vpc_enable_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az
  private_subnets        = var.vpc_private_subnets
  public_subnets         = var.vpc_public_subnets
  tags = {
    "kubernetes.io/cluster/eks-${var.stack}" = "shared"
    "Organization"                           = var.organization
    "Owner"                                  = var.stack_owner
    "Stack"                                  = var.stack
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/eks-${var.stack}" = "shared"
    "kubernetes.io/role/elb"                 = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/eks-${var.stack}" = "shared"
    "kubernetes.io/role/internal-elb"        = "1"
  }
}
