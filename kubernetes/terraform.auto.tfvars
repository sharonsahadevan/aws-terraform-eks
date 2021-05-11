# common
module      = "eks"
stack_owner = "sharon"
region      = "us-west-2"

# eks 
eks_cluster_version                                = 1.19
eks_enable_irsa                                    = true
eks_cluster_endpoint_public_access                 = true
eks_cluster_endpoint_private_access                = true
eks_cluster_create_endpoint_private_access_sg_rule = true
eks_nodegroup_volume_size                          = 5
eks_nodegroup_instance_types                       = ["t2.micro"]
eks_cluster_endpoint_public_access_cidrs           = ["0.0.0.0/0"]
eks_cluster_endpoint_private_access_cidrs          = ["0.0.0.0/0"]
eks_nodegroup_desired_capacity                     = 1
eks_nodegroup_max_capacity                         = 1
eks_nodegroup_min_capacity                         = 1
eks_nodegroup_volume_type                          = "gp2"
eks_nodegroup_ebs_delete_on_termination            = true
create_readonly_role                               = true
force_detach_policies                              = true
readonly_role_requires_mfa                         = true
