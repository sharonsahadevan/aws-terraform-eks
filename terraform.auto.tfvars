# common

organization = "redseal"
application  = "ctp"
stack_owner  = "terraform"
region       = "us-west-2"
account_id   = 633110707374 // need to create a variable placeholder in terraform cloud

# DNS
#dns_enabled = true

# VPC
vpc_private_subnets        = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
vpc_public_subnets         = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
vpc_cidr                   = "10.1.0.0/16"
vpc_enable_nat_gateway     = true
vpc_single_nat_gateway     = true
vpc_enable_dns_hostnames   = true
vpc_enable_s3_endpoint     = true
vpc_vpc_description        = "redseal vpc"
vpc_one_nat_gateway_per_az = true

# eks 
eks_cluster_version                                = 1.19
eks_enable_irsa                                    = true
eks_cluster_endpoint_public_access                 = true
eks_cluster_endpoint_private_access                = true
eks_cluster_create_endpoint_private_access_sg_rule = true
eks_nodegroup_volume_size                          = 100
#eks_nodegroup_volume_type                               = "gp2"
#eks_nodegroup_ebs_delete_on_termination                 = true
eks_tenant_services_instance_types                      = ["m5.2xlarge"]
eks_observability_instance_types                        = ["m5.2xlarge"]
eks_shared_services_instance_types                      = ["m5.xlarge"]
eks_cluster_endpoint_public_access_cidrs                = ["0.0.0.0/0"]
eks_cluster_endpoint_private_access_cidrs               = ["0.0.0.0/0"]
eks_tenant_services_desired_capacity                    = 3
eks_tenant_services_max_capacity                        = 5
eks_tenant_services_min_capacity                        = 2
eks_shared_services_desired_capacity                    = 3
eks_shared_services_max_capacity                        = 3
eks_shared_services_min_capacity                        = 2
eks_observability_desired_capacity                      = 3
eks_observability_max_capacity                          = 3
eks_observability_min_capacity                          = 2
eks_tenant_nodegroup_volume_size                        = 100
eks_shared_services_nodegroup_volume_size               = 100
eks_observability_nodegroup_volume_size                 = 100
eks_shared_services_nodegroup_volume_type               = "gp2"
eks_tenant_nodegroup_volume_type                        = "gp2"
eks_observability_nodegroup_volume_type                 = "gp2"
eks_tenant_nodegroup_ebs_delete_on_termination          = true
eks_shared_services_nodegroup_ebs_delete_on_termination = true
eks_observability_nodegroup_ebs_delete_on_termination   = true

# eks_devops_assumable_roles    // need to review -  need to creat a role
# create_readonly_role       = true
# force_detach_policies      = true
# readonly_role_requires_mfa = true


# RDS
rds_engine_version                  = "12.4"
rds_engine                          = "aurora-postgresql"
rds_create_security_group           = true
rds_deletion_protection             = true
rds_apply_immediately               = false
rds_skip_final_snapshot             = true
rds_enabled_cloudwatch_logs_exports = ["postgresql"]
rds_iam_role_path                   = "/"
rds_instance_type                   = "db.r5.large"
rds_instance_type_replica           = "db.t3.large"
rds_allowed_cidr_blocks             = []
rds_replica_count                   = 1
rds_replica_scale_enabled           = false
rds_replica_scale_min               = 1
rds_replica_scale_max               = 1
rds_monitoring_interval             = 60
rds_iam_role_max_session_duration   = 3600
rds_backup_retention_period         = 7
rds_preferred_backup_window         = "01:00-03:00"
rds_preferred_maintenance_window    = "sun:04:00-sun:06:00"



# security groups
rds_sg_description        = "Ingres from all EKS Pods in the staging eks cluster"
rds_sg_egress_cidr_blocks = ["0.0.0.0/0"]
rds_sg_egress_rules       = ["all-all"]


# alb
alb_create_lb                        = true
alb_drop_invalid_header_fields       = true
alb_enable_cross_zone_load_balancing = true
alb_enable_deletion_protection       = true
alb_enable_http2                     = true
alb_idle_timeout                     = 60
alb_ip_address_type                  = "ipv4"
alb_listener_ssl_policy_default      = "ELBSecurityPolicy-TLS-1-2-2017-01"
alb_load_balancer_create_timeout     = "10m"
alb_load_balancer_delete_timeout     = "10m"
alb_load_balancer_type               = "application"
#alb_load_balancer_update_timeout     = "10m"
alb_internal                               = false
alb_self_signed_cert_algorithm             = "RSA"
alb_self_signed_cert_validity_period_hours = 8760 // 1 year

# alb security group
alb_sg_name               = "alb_sg"
alb_sg_description        = "Allow traffic via port 80,443"
alb_sg_egress_cidr_blocks = ["0.0.0.0/0"]
alb_sg_egress_rules       = ["all-all"]
alb_sg_ingress_with_cidr_blocks = [{
  from_port   = 80,
  to_port     = 80,
  protocol    = "tcp",
  description = "Allow tcp traffic on port 80",
  cidr_blocks = "0.0.0.0/0",
  },
  {
    from_port   = 443,
    to_port     = 443,
    protocol    = "tcp",
    description = "Allow tcp traffic on port 443",
  cidr_blocks = "0.0.0.0/0", },
]


# wafv2
waf_name              = "ctp-wafv2"
blacklisted_addresses = []
waf_scope             = "REGIONAL"
waf_associate_alb     = true


# ECR
# ecr_enabled              = false
# ecr_namespace            = "redseal"
# ecr_stage                = ""
# ecr_name                 = "ecr"
# ecr_image_tag_mutability = "IMMUTABLE"
# ecr_max_image_count      = 500


# iam 
iam_create_role                        = true
iam_looker_email_role_name             = "LookerEmailRole"
role_requires_mfa                      = true
number_of_custom_role_policy_arns      = 1
iam_policy_name                        = "SesSendingAccess"
iam_prometheus_password_reset_required = false
iam_looker_password_reset_required     = false
iam_prometheus_name                    = "PrometheusEmail"
prometheus_force_destroy               = true
looker_password_reset_required         = false
iam_looker_name                        = "LookerCodeCommit"
iam_user_force_destroy                 = true
iam_looker_email_user_policy_arn       = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
looker_force_destroy                   = true