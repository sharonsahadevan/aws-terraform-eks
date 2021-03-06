variable "region" {
  type        = string
  description = "cluster deployed region"
  default     = "us-east-1"
}


variable "enable_irsa" {
  description = "Whether to create OpenID Connect Provider for EKS to enable IRSA"
  type        = string
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  default     = true
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

variable "cluster_version" {
  type    = number
  default = 1.19
}

variable "disk_size" {
  type        = number
  default     = 5
  description = "Disk Size in GiB for worker nodes."
}

variable "nodegroup_instance_types" {
  default = ["t2.micro"]
}

variable "nodegroup_desired_capacity" {
  default = 1
}

variable "nodegroup_max_capacity" {
  default = 1
}

variable "nodegroup_min_capacity" {
  default = 1
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


variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`."
  default     = false
}


variable "nodegroup_volume_size" {
  type    = number
  default = 5
}

variable "nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}




