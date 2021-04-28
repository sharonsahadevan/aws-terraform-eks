# eks
cluster_version                 = 1.18
enable_irsa                     = true
cluster_endpoint_public_access  = false
cluster_endpoint_private_access = true
workers_group_defaults          = "gp2"

# eks_devops_assumable_roles
create_readonly_role       = true
force_detach_policies      = true
readonly_role_requires_mfa = true