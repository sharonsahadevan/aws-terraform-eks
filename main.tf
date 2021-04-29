terraform {
  required_version = ">=0.14"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source                 = "../modules/network"
  cidr                   = var.vpc_cidr
  name                   = "vpc-${var.stack}"
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

module "eks" {
  source                                              = "../modules/eks"
  cluster_name                                        = "eks-${var.stack}"
  map_roles                                           = var.eks_map_roles
  map_users                                           = var.eks_map_users
  map_accounts                                        = var.eks_map_accounts
  stack_name                                          = var.stack
  stack_owner                                         = var.stack_owner
  cluster_version                                     = var.eks_cluster_version
  subnets                                             = module.vpc.private_subnets
  vpc_id                                              = module.vpc.vpc_id
  enable_irsa                                         = var.eks_enable_irsa
  cluster_endpoint_public_access                      = var.eks_cluster_endpoint_public_access
  cluster_endpoint_private_access                     = var.eks_cluster_endpoint_private_access
  cluster_create_endpoint_private_access_sg_rule      = var.eks_cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs               = var.eks_cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access_cidrs                = var.eks_cluster_endpoint_public_access_cidrs
  tenant_services_instance_types                      = var.eks_tenant_services_instance_types
  observability_instance_types                        = var.eks_observability_instance_types
  shared_services_instance_types                      = var.eks_shared_services_instance_types
  alb_security_group_id                               = module.alb_sg.alb_sg_id
  tenant_services_desired_capacity                    = var.eks_tenant_services_desired_capacity
  tenant_services_max_capacity                        = var.eks_tenant_services_max_capacity
  tenant_services_min_capacity                        = var.eks_tenant_services_min_capacity
  shared_services_desired_capacity                    = var.eks_shared_services_desired_capacity
  shared_services_max_capacity                        = var.eks_shared_services_max_capacity
  shared_services_min_capacity                        = var.eks_shared_services_min_capacity
  observability_desired_capacity                      = var.eks_observability_desired_capacity
  observability_max_capacity                          = var.eks_observability_max_capacity
  observability_min_capacity                          = var.eks_observability_min_capacity
  tenant_nodegroup_volume_size                        = var.eks_tenant_nodegroup_volume_size
  tenant_nodegroup_volume_type                        = var.eks_tenant_nodegroup_volume_type
  tenant_nodegroup_ebs_delete_on_termination          = var.eks_tenant_nodegroup_ebs_delete_on_termination
  shared_services_nodegroup_volume_size               = var.eks_shared_services_nodegroup_volume_size
  shared_services_nodegroup_volume_type               = var.eks_shared_services_nodegroup_volume_type
  shared_services_nodegroup_ebs_delete_on_termination = var.eks_shared_services_nodegroup_ebs_delete_on_termination
  observability_nodegroup_volume_size                 = var.eks_observability_nodegroup_volume_size
  observability_nodegroup_volume_type                 = var.eks_observability_nodegroup_volume_type
  observability_nodegroup_ebs_delete_on_termination   = var.eks_observability_nodegroup_ebs_delete_on_termination
  tags = {
    "Organization" = var.organization
    "Application"  = var.application
    "Owner"        = var.stack_owner
    "Stack"        = var.stack
    "Name"         = "eks-${var.stack}"
  }
}
