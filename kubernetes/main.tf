locals {
  Owner = "sharon"
  Name  = "eks-example"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "sharon-demo"
    workspaces = {
      name = "network"
    }
  }
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name,
    ]
  }
}

module "eks" {
  source                                         = "terraform-aws-modules/eks/aws"
  version                                        = "15.1.0"
  cluster_name                                   = local.Name
  cluster_version                                = var.cluster_version
  subnets                                        = data.terraform_remote_state.vpc.outputs.private_subnets
  write_kubeconfig                               = var.write_kubeconfig
  vpc_id                                         = data.terraform_remote_state.vpc.outputs.vpc_id
  enable_irsa                                    = var.enable_irsa
  cluster_endpoint_public_access                 = var.cluster_endpoint_public_access
  cluster_endpoint_private_access                = var.cluster_endpoint_private_access
  cluster_create_endpoint_private_access_sg_rule = var.cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access_cidrs           = var.cluster_endpoint_public_access_cidrs
  map_roles                                      = var.map_roles
  map_users                                      = var.map_users
  map_accounts                                   = var.map_accounts
  tags = {
    "kubernetes.io/cluster/eks-${local.Name}" = "shared"
    "Owner"                                   = local.Owner
    "Name"                                    = local.Name
  }

  node_groups_defaults      = {}
  cluster_enabled_log_types = ["api", "audit"]
  node_groups = {
    example_node_group = {
      desired_capacity        = var.nodegroup_desired_capacity
      max_capacity            = var.nodegroup_max_capacity
      min_capacity            = var.nodegroup_min_capacity
      instance_types          = var.nodegroup_instance_types
      launch_template_id      = aws_launch_template.default.id
      launch_template_version = aws_launch_template.default.default_version

      k8s_labels = {
        "redseal.net/role" = "example-node-group"
      }
      additional_tags = {
        "Stack Name"       = local.Name
        "Owner"            = local.Owner
        "redseal.net/role" = "example-node-group"
      }
    },
  }

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

}


resource "aws_kms_key" "eks" {
  description         = "EKS Secret Encryption Key"
  enable_key_rotation = true

  tags = {
    "Name"  = local.Name
    "Owner" = local.Owner
  }

}


