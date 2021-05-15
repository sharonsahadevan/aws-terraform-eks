# common
application = "demo"
stack_owner = "sharon"
region      = "us-east-1"
stack       = "example"

# VPC
vpc_private_subnets        = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
vpc_public_subnets         = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
vpc_cidr                   = "10.1.0.0/16"
vpc_enable_nat_gateway     = true
vpc_single_nat_gateway     = true
vpc_enable_dns_hostnames   = true
vpc_enable_s3_endpoint     = true
vpc_vpc_description        = "demo vpc"
vpc_one_nat_gateway_per_az = true

# eks 
eks_cluster_version                                   = 1.19
eks_enable_irsa                                       = true
eks_cluster_endpoint_public_access                    = true
eks_cluster_endpoint_private_access                   = true
eks_cluster_create_endpoint_private_access_sg_rule    = true
eks_nodegroup_volume_size                             = 100
eks_tenant_services_instance_types                    = ["t2.micro"]
eks_cluster_endpoint_public_access_cidrs              = ["0.0.0.0/0"]
eks_cluster_endpoint_private_access_cidrs             = ["0.0.0.0/0"]
eks_tenant_services_desired_capacity                  = 1
eks_tenant_services_max_capacity                      = 1
eks_tenant_services_min_capacity                      = 1
eks_tenant_nodegroup_volume_size                      = 5
eks_shared_services_nodegroup_volume_type             = "gp2"
eks_observability_nodegroup_ebs_delete_on_termination = true

# eks_devops_assumable_roles    // need to review -  need to creat a role
# create_readonly_role       = true
# force_detach_policies      = true
# readonly_role_requires_mfa = true
