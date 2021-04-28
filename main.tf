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

# resource "aws_iam_service_linked_role" "autoscaling" {
#    aws_service_name = "autoscaling.amazonaws.com"
#    description      = "Default Service-Linked Role enables access to AWS Services and Resources used or managed by Auto Scaling"
# }

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

# RDS
# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "db_subnet_group_${var.stack}"
#   subnet_ids = module.vpc.private_subnets
#   tags = {
#     "Organization" = var.organization
#     "Owner"        = var.stack_owner
#     "Stack"        = var.stack
#     "Name"         = "db_subnet_group_${var.stack}"
#   }

# }

module "db" {
  source                          = "../modules/rds"
  create_cluster                  = true
  name                            = "rds-${var.stack}"
  stack                           = var.stack
  username                        = var.username
  password                        = var.rds_master_password
  engine                          = var.rds_engine
  engine_version                  = var.rds_engine_version
  instance_type                   = var.rds_instance_type
  backup_retention_period         = var.rds_backup_retention_period
  instance_type_replica           = var.rds_instance_type_replica
  vpc_id                          = module.vpc.vpc_id
  create_security_group           = var.rds_create_security_group
  allowed_security_groups         = [module.eks.worker_security_group_id]
  allowed_cidr_blocks             = var.rds_allowed_cidr_blocks
  replica_count                   = var.rds_replica_count
  replica_scale_enabled           = var.rds_replica_scale_enabled
  replica_scale_min               = var.rds_replica_scale_min
  replica_scale_max               = var.rds_replica_scale_max
  monitoring_interval             = var.rds_monitoring_interval
  iam_role_max_session_duration   = var.rds_iam_role_max_session_duration
  apply_immediately               = var.rds_apply_immediately
  skip_final_snapshot             = var.rds_skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports
  performance_insights_enabled    = var.performance_insights_enabled
  preferred_maintenance_window    = var.rds_preferred_maintenance_window
  rds_subnet_ids                  = module.vpc.private_subnets
  preferred_backup_window         = var.rds_preferred_backup_window

  cluster_tags = {
    "Organization" = var.organization
    "Application"  = var.application
    "Owner"        = var.stack_owner
    "Stack"        = var.stack
    "Name"         = "rds-${var.stack}"
  }
}


# ECR
#ECR IAM role has to be created with necessary permission before executing this module. Later, IAM role creation resource will be added.
# module "ecr" {
#   source               = "../modules/ecr"
#   enabled              = var.ecr_enabled
#   namespace            = var.ecr_namespace
#   stage                = var.ecr_stage
#   name                 = "ecr-${var.stack}"
#   environment          = var.stack
#   image_tag_mutability = var.ecr_image_tag_mutability
#   max_image_count      = var.ecr_max_image_count
#   tags = {
#     "Organization" = var.organization,
#     "Application"  = var.application,
#     "Owner"        = var.stack_owner,
#     "Stack"        = var.stack,
#     "Name"         = "ecr-${var.stack}"

#   }

# }


module "dns" {
  #count  = var.dns_enabled ? 1 : 0
  source = "../modules/dns"

  stack_name                 = var.stack
  stack_zone                 = local.stack_zone
  stack_owner                = var.stack_owner
  kubernetes_oidc_issuer_url = module.eks.kubernetes_oidc_issuer_url
  alb_main_dns_name          = module.alb.this_lb_dns_name
  alb_main_zone_id           = module.alb.this_lb_zone_id

  okta_org_name = var.okta_org_name
  okta_base_url = var.okta_base_url
}

###OIDC application
module "oidc" {
  source     = "../modules/okta-oidc"
  stack_zone = local.stack_zone
}


# ########## ALB ##############################################
module "alb" {
  source                           = "../modules/alb"
  name                             = "alb-${var.stack}"
  subnets                          = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  vpc_id                           = module.vpc.vpc_id
  access_logs                      = var.alb_access_logs
  create_lb                        = var.alb_create_lb
  drop_invalid_header_fields       = var.alb_drop_invalid_header_fields
  enable_cross_zone_load_balancing = var.alb_enable_cross_zone_load_balancing
  enable_deletion_protection       = var.alb_enable_deletion_protection
  enable_http2                     = var.alb_enable_http2
  extra_ssl_certs                  = var.alb_extra_ssl_certs
  https_listener_rules             = var.alb_https_listener_rules
  idle_timeout                     = var.alb_idle_timeout
  internal                         = var.alb_internal
  ip_address_type                  = var.alb_ip_address_type
  lb_tags                          = var.alb_lb_tags
  listener_ssl_policy_default      = var.alb_listener_ssl_policy_default
  load_balancer_create_timeout     = var.alb_load_balancer_create_timeout
  load_balancer_delete_timeout     = var.alb_load_balancer_delete_timeout
  security_groups                  = [module.alb_sg.alb_sg_id]
  alb_target_group_name            = "alb-tg-${var.stack}"
  oidc_issuer                      = module.okta_auth_server.auth_server_issuer
  client_id                        = module.oidc.client_id
  client_secret                    = module.oidc.client_secret
  eks_node_groups                  = module.eks.node_groups
  alb_target_group_arn             = module.alb.target_group_arns[0]
  organization                     = var.organization
  validity_period_hours            = var.alb_self_signed_cert_validity_period_hours
  domain                           = local.stack_zone
  public_cert                      = var.alb_tls_cert
  private_key                      = var.alb_tls_key
  public_chain                     = var.alb_tls_cert_chain
  inline_hook_uri_path             = var.inline_hook_uri_path
  tags = {
    "Organization" = var.organization,
    "Application"  = var.application,
    "Owner"        = var.stack_owner,
    "Stack"        = var.stack,
    "Name"         = "alb-${var.stack}"
  }
  target_group_tags = {
    "Organization" = var.organization,
    "Application"  = var.application,
    "Owner"        = var.stack_owner,
    "Stack"        = var.stack,
    "Name"         = "alb-tg-${var.stack}"

  }
}



module "okta_mfa" {
  source   = "../modules/okta-mfa"
  mfa_name = var.mfa_name

}


# ###########################################################
# #Call the module to create inline_hook using the parameter.
# ###########################################################

module "okta_inline_hook" {

  source                      = "../modules/okta_inlinehook"
  inline_hook_version         = var.inline_hook_version
  inline_hook_channel_version = var.inline_hook_channel_version
  inline_hook_channel_uri     = "https://${local.stack_zone}${var.inline_hook_uri_path}"
  inline_hook_channel_method  = var.inline_hook_channel_method

}
# ####################################################################
# #Call the module to create Authorization Server using the parameter.
# ####################################################################

module "okta_auth_server" {

  source                  = "../modules/okta_auth_server"
  auth_server_name        = var.stack
  auth_server_issuer_mode = var.auth_server_issuer_mode
  auth_server_policy_name = "Auth Policy for the ${var.stack} stack"
  auth_policy_rule_name   = var.auth_policy_rule_name
  inline_hook_id          = module.okta_inline_hook.inline_hook_id
  stack_zone              = local.stack_zone


}

# ##########################################################
# #Call the module to create Email templates under Okta.
# ###########################################################

module "okta_email_template" {
  source = "../modules/okta_email_template"
}

# ###########################################################


####################################
# security groups                  #
####################################

# ALB security group
module "alb_sg" {
  source                   = "../modules/security_group"
  vpc_id                   = module.vpc.vpc_id
  name                     = var.alb_sg_name
  description              = var.alb_sg_description
  egress_cidr_blocks       = var.alb_sg_egress_cidr_blocks
  egress_rules             = var.alb_sg_egress_rules
  ingress_with_cidr_blocks = var.alb_sg_ingress_with_cidr_blocks
  tags = {
    "Organization" = var.organization
    "Application"  = var.application
    "Owner"        = var.stack_owner
    "Stack"        = var.stack
    "Name"         = "alb-sg-${var.stack}"
  }

}

###########################################################
#Call the module to create authentication policies (password, signon) under Okta.
###########################################################
module "okta_authn" {
  source = "../modules/okta_authn"
}
###########################################################

# wafv2
module "wafv2" {
  source               = "../modules/wafv2"
  name                 = var.waf_name
  scope                = var.waf_scope
  alb_arn              = module.alb.this_lb_arn
  associate_alb        = var.waf_associate_alb
  filtered_header_rule = var.waf_filtered_header_rule
  group_rules          = var.waf_group_rules
  ip_rate_based_rule   = var.waf_ip_rate_based_rule
  ip_sets_rule         = var.waf_ip_sets_rule
  managed_rules        = var.waf_managed_rules
  tags = {
    "Organization" = var.organization
    "Application"  = var.application
    "Owner"        = var.stack_owner
    "Stack"        = var.stack
    "Name"         = "wafv2-${var.stack}"
  }
}



# iam_prometheus_user
module "iam_prometheus_user" {
  source                           = "../modules/iam_user"
  iam_username                     = "${var.iam_prometheus_name}_${var.stack}"
  iam_user_force_destroy           = var.iam_user_force_destroy
  iam_user_password_reset_required = var.iam_prometheus_password_reset_required
  iam_policy_arn                   = module.iam_ses_sending_access_policy.iam_ses_sending_access_policy_arn
  iam_tags = {
    "Organization" = var.organization
    "Application"  = var.application
    "Owner"        = var.stack_owner
    "Stack"        = var.stack
    "Name"         = "${var.iam_prometheus_name}"
  }
}


# iam_looker_user
module "iam_looker_email_user" {
  source                           = "../modules/iam_user"
  iam_username                     = "${var.iam_looker_name}_${var.stack}"
  iam_user_force_destroy           = var.iam_user_force_destroy
  iam_user_password_reset_required = var.iam_looker_password_reset_required
  iam_policy_arn                   = var.iam_looker_email_user_policy_arn
  iam_tags = {
    "Organization" = var.organization
    "Application"  = var.application
    "Owner"        = var.stack_owner
    "Stack"        = var.stack
    "Name"         = "${var.iam_looker_name}"
  }
}

# SES sending access policy
module "iam_ses_sending_access_policy" {
  source          = "../modules/iam_policy"
  iam_policy_name = "${var.iam_policy_name}-${var.stack}"
  iam_policy_doc = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ses:SendRawEmail",
        "Resource" : "*"
      }
    ]
  })
}



# LookerEmailRole 
module "looker_email_role" {
  source                                = "../modules/iam_role"
  iam_custom_role_policy_arns           = [module.iam_ses_sending_access_policy.iam_ses_sending_access_policy_arn, "${var.iam_looker_email_user_policy_arn}"]
  iam_create_role                       = var.iam_create_role
  iam_account_id                        = var.account_id
  iam_role_name                         = var.iam_looker_email_role_name
  iam_role_requires_mfa                 = false
  iam_number_of_custom_role_policy_arns = 1
  iam_tags = {
    "Organization" = var.organization
    "Application"  = var.application
    "Owner"        = var.stack_owner
    "Stack"        = var.stack
    "Name"         = "${var.iam_looker_email_role_name}"
  }
}

