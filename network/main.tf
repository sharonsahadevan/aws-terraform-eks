locals {
  name = "vpc-example"
  tags = {
    Owner       = "sharon"
    Environment = "example"
    Name        = "vpc-example"
  }
}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "3.0.0"
  cidr                   = var.vpc_cidr
  name                   = "vpc-${var.stack}"
  azs                    = ["${local.region}a", "${local.region}b", "${local.region}c"]
  enable_dns_hostnames   = var.vpc_enable_dns_hostnames
  single_nat_gateway     = var.vpc_single_nat_gateway
  enable_nat_gateway     = var.vpc_enable_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az
  private_subnets        = var.vpc_private_subnets
  public_subnets         = var.vpc_public_subnets
  tags = {
    "kubernetes.io/cluster/eks-${var.stack}" = "shared"
    "Owner"                                  = "${local.Owner}"
    Environment                              = "${local.Environment}"
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
