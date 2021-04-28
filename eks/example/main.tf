module "eks" {
  source                                         = "./modules/eks"
  account_id                                     = var.account_id // sensitive variable
  cluster_name                                   = var.cluster_name
  cluster_version                                = var.cluster_version
  subnets                                        = module.vpc.private_subnets
  vpc_id                                         = module.vpc.vpc_id
  enable_irsa                                    = var.enable_irsa
  cluster_endpoint_public_access                 = var.cluster_endpoint_public_access
  cluster_endpoint_private_access                = var.cluster_endpoint_private_access
  cluster_create_endpoint_private_access_sg_rule = var.cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access_cidrs           = var.cluster_endpoint_public_access_cidrs
  tags                                           = var.eks_tags
  map_roles = [
    {
      rolearn  = "${module.eks_devops_assumable_roles.readonly_iam_role_arn}"
      username = "devops-user"
      groups   = ["system:masters"]
    },
  ]
  workers_group_defaults = var.workers_group_defaults
  worker_groups = [
    {
      name                          = "${var.worker_group1_name}"
      instance_type                 = "${var.worker_group1_instance_type}"
      asg_desired_capacity          = var.worker_group1_asg_capacity
      additional_security_group_ids = [module.eks_wg_one_sg.eks_wg_one_sg_id]
    },
    {
      name                          = "${var.worker_group2_name}"
      instance_type                 = "${var.worker_group2_instance_type}"
      asg_desired_capacity          = var.worker_group2_asg_capacity
      additional_security_group_ids = [module.eks_wg_two_sg.eks_wg_two_sg_id]
    },
    {
      name                          = "${var.worker_group3_name}"
      instance_type                 = "${var.worker_group3_instance_type}"
      asg_desired_capacity          = var.worker_group3_asg_capacity
      additional_security_group_ids = [module.eks_wg_three_sg.eks_wg_three_sg_id]
    },

  ]
}

# eks management node 1
module "eks_wg_one_sg" {
  source                   = "./modules/security_group"
  vpc_id                   = module.vpc.vpc_id
  name                     = var.eks_wg_one_sg_name
  description              = var.eks_wg_one_sg_description
  egress_cidr_blocks       = var.eks_wg_one_sg_egress_cidr_blocks
  egress_rules             = var.eks_wg_one_sg_egress_rules
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

}

# eks management node 2
module "eks_wg_two_sg" {
  source                   = "./modules/security_group"
  vpc_id                   = module.vpc.vpc_id
  name                     = var.eks_wg_two_sg_name
  description              = var.eks_wg_two_sg_description
  egress_cidr_blocks       = var.eks_wg_two_sg_egress_cidr_blocks
  egress_rules             = var.eks_wg_two_sg_egress_rules
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

}


# eks management node 3
module "eks_wg_three_sg" {
  source                   = "./modules/security_group"
  vpc_id                   = module.vpc.vpc_id
  name                     = var.eks_wg_three_sg_name
  description              = var.eks_wg_three_sg_description
  egress_cidr_blocks       = var.eks_wg_three_sg_egress_cidr_blocks
  egress_rules             = var.eks_wg_three_sg_egress_rules
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

}