locals {
  name        = "vpc-example"
  Owner       = "sharon"
  Environment = "example"
  Name        = "vpc-example"
  Stack       = "example"

}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "3.0.0"
  cidr                   = var.cidr
  name                   = "vpc-${local.Stack}"
  azs                    = ["${var.region}a", "${var.region}b", "${var.region}c"]
  enable_dns_hostnames   = var.enable_dns_hostnames
  single_nat_gateway     = var.single_nat_gateway
  enable_nat_gateway     = var.enable_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  private_subnets        = var.private_subnets
  public_subnets         = var.public_subnets
  tags = {
    "kubernetes.io/cluster/eks-${var.stack}" = "shared"
    "Owner"                                  = "${local.Owner}"
    "Environment"                            = "${local.Environment}"
    "Name"                                   = "${local.Name}"
    "Stack"                                  = "${local.Stack}"

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
