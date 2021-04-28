# common

# profile      = "sharon" // change it
# environment  = "dev"
# organization = "redseal"
# application  = "ctp"
# stack_owner  = "terraform"

stack = "dev"



# VPC
#region                 = "us-west-1"
# private_subnets        = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
# public_subnets         = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
# cidr                   = "10.1.0.0/16"
# enable_nat_gateway     = true
# single_nat_gateway     = true
# enable_dns_hostnames   = true
# enable_s3_endpoint     = true
# vpc_description        = "redseal vpc"
# one_nat_gateway_per_az = true


#eks
#cluster_name                                   = "redseal-dev-eks-test1"
#cluster_version                                = "1.19"
#enable_irsa                                    = true
# cluster_endpoint_public_access                 = true
# cluster_endpoint_private_access                = true
#cluster_create_endpoint_private_access_sg_rule = true
# tenant_services_instance_types                 = ["m5.2xlarge"]
# observability_instance_types                   = ["m5.2xlarge"]
# shared_services_instance_types                 = ["m5.xlarge"]
# cluster_endpoint_public_access_cidrs           = ["0.0.0.0/0"]
# cluster_endpoint_private_access_cidrs          = ["0.0.0.0/0"]
# tenant_services_desired_capacity               = 3
# tenant_services_max_capacity                   = 5
# tenant_services_min_capacity                   = 2
# shared_services_desired_capacity               = 3
# shared_services_max_capacity                   = 3
# shared_services_min_capacity                   = 2
# observability_desired_capacity                 = 3
# observability_max_capacity                     = 3
# observability_min_capacity                     = 2
eks_map_roles = []


# # alb security group
# alb_sg_name               = "alb_sg"
# alb_sg_description        = "Allow traffic via port 80,443"
# alb_sg_egress_cidr_blocks = ["0.0.0.0/0"]
# alb_sg_egress_rules       = ["all-all"]
# alb_sg_ingress_with_cidr_blocks = [{
#   from_port   = 80,
#   to_port     = 80,
#   protocol    = "tcp",
#   description = "Allow tcp traffic on port 80",
#   cidr_blocks = "0.0.0.0/0",
#   },
#   {
#     from_port   = 443,
#     to_port     = 443,
#     protocol    = "tcp",
#     description = "Allow tcp traffic on port 443",
#   cidr_blocks = "0.0.0.0/0", },
# ]



# alb
#name     = "redseal-ctp-dev-alb" // underscores are not allowed.
#internal = false
#domain   = "staging.preview.redseal.net"




# RDS
# rds_name                            = "redseal-ctp-dev-rds"
# rds_instance_type                   = "db.r5.large"
# rds_instance_type_replica           = "db.t3.large"
# rds_allowed_cidr_blocks             = []
# rds_replica_count                   = 1
# rds_replica_scale_enabled           = false
# rds_replica_scale_min               = 1
# rds_replica_scale_max               = 1
#rds_monitoring_interval             = 60
#rds_iam_role_max_session_duration   = 3600 // Maximum session duration (in seconds) that you want to set for the role
#rds_apply_immediately               = false
# rds_db_cluster_parameter_group_name = "redseal-ctp-dev-db-cluster-parameter-group" // not using
# rds_db_parameter_group_name         = "redseal-ctp-dev-db-parameter-group" // not using
# rds_backup_retention_period         = 7
# rds_skip_final_snapshot             = true


# RDS security group // need to move this rds module. Refer master rds SG
db_sg_name               = "redseal-ctp-dev-db-sg"
db_sg_description        = "redseal ctp dev db security group"
db_sg_egress_cidr_blocks = ["0.0.0.0/0"]
db_sg_egress_rules       = ["all-all"]
db_sg_ingress_with_cidr_blocks = [{
  from_port   = 3306,
  to_port     = 3306,
  protocol    = "tcp",
  description = "Allow tcp traffic on port 3306",
  cidr_blocks = "0.0.0.0/0",
}, ]


# ECR
ecr_enabled              = false
ecr_namespace            = "redseal"
ecr_stage                = ""
ecr_name                 = "ecr"
ecr_image_tag_mutability = "IMMUTABLE"
ecr_max_image_count      = 500

