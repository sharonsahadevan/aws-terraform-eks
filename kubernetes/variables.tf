variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "region" {
  type        = string
  description = "cluster deployed region"
  default     = "us-west-1"
}

variable "subnets" {
  description = "cluster deployed subnets"
  type        = list(string)
}
variable "cluster_name" {
  description = "cluster name"
  type        = string
}

variable "enable_irsa" {
  description = "Whether to create OpenID Connect Provider for EKS to enable IRSA"
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  default     = false
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  default     = true
}

variable "cluster_create_endpoint_private_access_sg_rule" {
  description = "cluster_create_endpoint_private_access_sg_rule "
  default     = false
}

variable "cluster_endpoint_private_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS private API server endpoint."
}
variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
}

#variable "account_id" {}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only."
}

variable "cluster_version" {
  type    = number
  default = 1.19
}

variable "disk_size" {
  type        = number
  default     = 50
  description = "Disk Size in GiB for worker nodes."
}

variable "shared_services_instance_types" {
  default = ["m5.xlarge"]
}

variable "tenant_services_instance_types" {
  default = ["m5.2xlarge"]
}

variable "observability_instance_types" {
  default = ["m5.2xlarge"]
}

variable "stack_owner" {
  type        = string
  default     = "devops"
  description = "Stack Owner"
}

variable "stack_name" {
  default     = "dev"
  description = "Name of the stack"
}


variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the EKS aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the EKS aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "alb_security_group_id" {
  description = "ALB Security Group to allow ingress into the Node Groups"
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`."
  default     = false
}




variable "tenant_services_desired_capacity" {}
variable "tenant_services_max_capacity" {}
variable "tenant_services_min_capacity" {}


variable "shared_services_desired_capacity" {}
variable "shared_services_max_capacity" {}
variable "shared_services_min_capacity" {}

variable "observability_desired_capacity" {}
variable "observability_max_capacity" {}
variable "observability_min_capacity" {}



variable "nodegroup_volume_size" {
  type    = number
  default = 100
}

variable "nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}

# tenant group
variable "tenant_nodegroup_volume_size" {
  type    = number
  default = 100
}

variable "tenant_nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "tenant_nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}

# shared-service group

variable "shared_services_nodegroup_volume_size" {
  type    = number
  default = 100
}

variable "shared_services_nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "shared_services_nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}

# observability group

variable "observability_nodegroup_volume_size" {
  type    = number
  default = 100
}

variable "observability_nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "observability_nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}