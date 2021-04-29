data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
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

# locals {
#   cluster_name = var.cluster_name
# }



module "eks" {
  source                                         = "terraform-aws-modules/eks/aws"
  version                                        = "15.1.0"
  cluster_name                                   = var.cluster_name
  cluster_version                                = var.cluster_version
  subnets                                        = var.subnets
  write_kubeconfig                               = var.write_kubeconfig
  vpc_id                                         = var.vpc_id
  enable_irsa                                    = var.enable_irsa
  cluster_endpoint_public_access                 = var.cluster_endpoint_public_access
  cluster_endpoint_private_access                = var.cluster_endpoint_private_access
  cluster_create_endpoint_private_access_sg_rule = var.cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access_cidrs           = var.cluster_endpoint_public_access_cidrs
  tags                                           = var.tags
  map_roles                                      = var.map_roles
  map_users                                      = var.map_users
  map_accounts                                   = var.map_accounts
  # node_groups_defaults = {
  #   ami_type  = "AL2_x86_64"
  #   disk_size = var.disk_size
  # }
  node_groups_defaults = {}
  cluster_enabled_log_types = ["api", "audit"]
  node_groups = {
    shared_services = {
      desired_capacity = var.shared_services_desired_capacity
      max_capacity     = var.shared_services_max_capacity
      min_capacity     = var.shared_services_min_capacity
      instance_types   = var.shared_services_instance_types
      launch_template_id      = aws_launch_template.shared_services_tmpl.id
      launch_template_version = aws_launch_template.shared_services_tmpl.default_version

      k8s_labels = {
        "redseal.net/role" = "shared-services"
      }
      additional_tags = {
        "Stack Name"       = var.stack_name
        "Owner"            = var.stack_owner
        "redseal.net/role" = "shared-services"
      }
    },
    observability_group = {
      desired_capacity  = var.observability_desired_capacity
      max_capacity      = var.observability_max_capacity
      min_capacity      = var.observability_min_capacity
      instance_types    = var.observability_instance_types
      launch_template_id      = aws_launch_template.observability_tmpl.id
      launch_template_version = aws_launch_template.default.default_version

      k8s_labels = {
        "redseal.net/role" = "observability"
      }
      additional_tags = {
        "Stack Name"       = var.stack_name
        "Owner"            = var.stack_owner
        "redseal.net/role" = "observability"
      }
    },
    tenant_group = {
      desired_capacity  = var.tenant_services_desired_capacity
      max_capacity      = var.tenant_services_max_capacity
      min_capacity      = var.tenant_services_min_capacity
      instance_types    = var.tenant_services_instance_types
      launch_template_id      = aws_launch_template.tenant_tmpl.id
      launch_template_version = aws_launch_template.default.default_version

      k8s_labels = {
        "redseal.net/role" = "tenant-services"
      }
      additional_tags = {
        "Stack Name"       = var.stack_name
        "Owner"            = var.stack_owner
        "redseal.net/role" = "tenant-services"
      }
    }
  }

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

}


resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
  enable_key_rotation = true

  tags = {
    Name         = var.cluster_name
    "Stack Name" = var.stack_name
    "Owner"      = var.stack_owner
  }

}


