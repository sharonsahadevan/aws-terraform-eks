# common
application = "demo"
stack_owner = "sharon"
region      = "us-east-1"
stack       = "eks-example"

# eks 
cluster_version                                = 1.19
enable_irsa                                    = true
cluster_endpoint_public_access                 = true
cluster_endpoint_private_access                = true
cluster_create_endpoint_private_access_sg_rule = true
nodegroup_volume_size                          = 5
nodegroup_instance_types                       = ["t2.micro"]
cluster_endpoint_public_access_cidrs           = ["0.0.0.0/0"]
cluster_endpoint_private_access_cidrs          = ["0.0.0.0/0"]
nodegroup_desired_capacity                     = 1
nodegroup_max_capacity                         = 1
nodegroup_min_capacity                         = 1
nodegroup_volume_type                          = "gp2"
nodegroup_ebs_delete_on_termination            = true


