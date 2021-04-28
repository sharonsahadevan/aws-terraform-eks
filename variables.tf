variable "account_id" {
  type        = number
  description = "account id"
}

variable "stack" {
  type        = string
  description = "Stack name"
  default     = "dev"
}

variable "stack_owner" {
  type        = string
  default     = "devops"
  description = "Stack Owner"
}

variable "profile" {
  type        = string
  description = "AWS profile to use"
  default     = "default"
}

variable "region" {
  type        = string
  description = "AWS region to use"
  default     = "us-west-1"
}

# tags

variable "organization" {
  type        = string
  description = "organization name"
  default     = "REDSEAL, INC"
}


variable "application" {
  type        = string
  description = "Application name"
  default     = "ctp"
}

###############################
# VPC
###############################

variable "vpc_cidr" {}
variable "vpc_public_subnets" {}
variable "vpc_private_subnets" {}
variable "vpc_enable_s3_endpoint" {}
variable "vpc_enable_dns_hostnames" {}
variable "vpc_enable_nat_gateway" {}
variable "vpc_single_nat_gateway" {}
variable "vpc_vpc_description" {}
variable "vpc_one_nat_gateway_per_az" {}

#################################
# EKS 
#################################
#variable "cluster_name" {}
variable "eks_cluster_version" {}
variable "eks_tenant_services_instance_types" {}
variable "eks_observability_instance_types" {}
variable "eks_shared_services_instance_types" {}
variable "eks_tenant_services_desired_capacity" {}
variable "eks_tenant_services_max_capacity" {}
variable "eks_tenant_services_min_capacity" {}
variable "eks_shared_services_desired_capacity" {}
variable "eks_shared_services_max_capacity" {}
variable "eks_shared_services_min_capacity" {}
variable "eks_observability_desired_capacity" {}
variable "eks_observability_max_capacity" {}
variable "eks_observability_min_capacity" {}
variable "eks_enable_irsa" {}
variable "eks_cluster_endpoint_public_access" {}
variable "eks_cluster_endpoint_private_access" {}
variable "eks_cluster_create_endpoint_private_access_sg_rule" {}
variable "eks_cluster_endpoint_private_access_cidrs" {}
variable "eks_cluster_endpoint_public_access_cidrs" {}

# variable "disk_size" {
#   type        = number
#   default     = 50
#   description = "Disk Size in GiB for worker nodes."
# }

variable "eks_map_roles" {
  type    = list(object({ rolearn = string, username = string, groups = list(string) }))
  default = []
}

variable "eks_map_users" {
  type    = list(object({ userarn = string, username = string, groups = list(string) }))
  default = []
}

variable "eks_map_accounts" {
  type    = list(string)
  default = []
}

variable "eks_tags" {
  type = map(string)
  default = {
    Organization = "redseal"
    Application  = "ctp"
    Owner        = "terraform"
    Stack        = "dev"
    Name         = "eks-dev"
  }
}

# variable "eks_nodegroup_volume_size" {
#   type    = number
#   default = 100
# }

# variable "eks_nodegroup_volume_type" {
#   type    = string
#   default = "gp2"
# }

# variable "eks_nodegroup_ebs_delete_on_termination" {
#   type    = bool
#   default = true
# }

# tenant group
variable "eks_tenant_nodegroup_volume_size" {
  type    = number
  default = 100
}

variable "eks_tenant_nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "eks_tenant_nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}

# shared-service group

variable "eks_shared_services_nodegroup_volume_size" {
  type    = number
  default = 100
}

variable "eks_shared_services_nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "eks_shared_services_nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}

# observability group

variable "eks_observability_nodegroup_volume_size" {
  type    = number
  default = 100
}

variable "eks_observability_nodegroup_volume_type" {
  type    = string
  default = "gp2"
}

variable "eks_observability_nodegroup_ebs_delete_on_termination" {
  type    = bool
  default = true
}

# alb sg variables
variable "alb_sg_name" {}
variable "alb_sg_description" {}
variable "alb_sg_egress_cidr_blocks" {}
variable "alb_sg_egress_rules" {}
variable "alb_sg_ingress_with_cidr_blocks" {}

##########################################
# rds postgresql variables               #
##########################################

variable "rds_name" {
  type    = string
  default = "redseal_ctp_dev_rds"
}
variable "rds_engine" {
  type    = string
  default = "aurora"
}
variable "rds_engine_version" {
  type    = string
  default = "5.6.10a"
}
variable "rds_instance_type" {
  type = string
}
variable "rds_instance_type_replica" {
  type = string
}

variable "rds_create_security_group" {
  type    = bool
  default = true
}
variable "rds_allowed_cidr_blocks" {
  type    = list(string)
  default = []
}
variable "rds_replica_count" {
  type    = number
  default = 1
}
variable "rds_replica_scale_enabled" {
  type    = bool
  default = true
}
variable "rds_replica_scale_min" {
  type    = number
  default = 2
}
variable "rds_replica_scale_max" {
  type = number
}
variable "rds_monitoring_interval" {
  type    = number
  default = 300

}
variable "rds_iam_role_use_name_prefix" {
  type    = bool
  default = false

}
variable "rds_iam_role_path" {
  type = string
}

variable "rds_iam_role_max_session_duration" {
  type = number
}
variable "rds_apply_immediately" {
  type    = bool
  default = false
}
variable "rds_skip_final_snapshot" {
  type    = bool
  default = true
}
variable "rds_enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Description: List of log types to export to cloudwatch - `audit`, `error`, `general`, `slowquery`, `postgresql`"
  default     = []

}

variable "rds_preferred_maintenance_window" {
  type        = string
  description = "When to perform DB maintenance"
}

variable "rds_deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
}

variable "rds_preferred_backup_window" {
  type        = string
  description = "When to perform DB backups"
}
variable "username" {
  type    = string
  default = "root"
}

variable "create_random_password" {
  type    = bool
  default = true
}

variable "performance_insights_enabled" {
  type    = bool
  default = true
}

variable "rds_backup_retention_period" {
  type        = number
  description = "How long to keep backups for (in days)"
  default     = 7
}

variable "rds_master_password" {
  type        = string
  description = "Master DB password. Note - when specifying a value here, 'create_random_password' should be set to `false`"
  default = null
}


# RDS security group

variable "rds_sg_description" {
  type = string
}

variable "rds_sg_egress_cidr_blocks" {
  type = list(string)
}

variable "rds_sg_egress_rules" {
  type = list(string)
}


##########################################
# ECR variables
##########################################
# variable "ecr_enabled" {
#   type    = bool
#   default = true
# }

# variable "ecr_namespace" {
#   type = string

# }

# variable "ecr_stage" {
#   type = string
# }

# variable "ecr_name" {
#   type = string
# }

# variable "ecr_max_image_count" {
#   type = number
# }


# variable "ecr_image_tag_mutability" {
#   type    = string
#   default = "IMMUTABLE"

# }
##########################################
# DNS variables               #
##########################################
# variable "dns_enabled" {
#   type        = bool
#   description = "Enable / Disable the DNS Module"
#   default     = true
# }

locals {
  preview_tld_zone = "preview.${var.dns_tld_zone}"
  effective_zone   = var.dns_is_preview ? local.preview_tld_zone : var.dns_tld_zone
  stack_zone       = var.dns_stack_zone_segment != "" ? "${var.dns_stack_zone_segment}.${local.effective_zone}" : "${var.stack}.${local.effective_zone}"
  login_fqdn       = "login.${local.stack_zone}"
}

variable "dns_tld_zone" {
  default     = "redseal.net"
  description = "Top Level Zone for the stack"
}

variable "dns_is_preview" {
  type        = bool
  default     = true
  description = "Generate stack zones under the parent preview Zone "
}

variable "dns_stack_zone_segment" {
  default     = ""
  description = "Zone name to be created for this stack. If this is empty, the stack_name will be used in stead."
}
variable "okta_org_name" {
  description = "Okta Org Name"
  default     = "redseal-cloud-dev"
}

variable "okta_base_url" {
  description = "Okta Base URI"
  default     = "oktapreview.com"
}

# ############################################
# #Okta Mfa
# ############################################
variable "mfa_name" {
  type    = list(string)
  default = ["google_otp", "okta_otp", "okta_push"]
}
# ############################################

# ############################################
# #Inline hooks variables
# ############################################

variable "inline_hook_version" {
  description = "The version of the hook. The currently-supported version is 1.0.0."
  type        = string
  default     = "1.0.0"
}

variable "inline_hook_channel_version" {
  description = "Version of the channel. The currently-supported version is 1.0.0. "
  type        = string
  default     = "1.0.0"
}

variable "inline_hook_channel_method" {
  description = "The request method to use. Default is POST."
  type        = string
  default     = "POST"
}
variable "inline_hook_uri_path" {
  description = "The URI Path used in the web hook request."
  type        = string
  default     = "/hooks/v1/accessinfo"
}



# ################################################################################
# #Auth Server variables
# ################################################################################

variable "auth_server_issuer_mode" {
  description = " Allows you to use a custom issuer URL. It can be set to CUSTOM_URL or ORG_URL. "
  type        = string
  default     = "ORG_URL"
}
# ########################################################
# #For okta_auth_server_policy
# #################################################
variable "auth_server_policy_name" {
  description = "The name of the Auth Server Policy. "
  type        = string
  default     = ""
}

# ##################################################

# #################################################
# #For okta_auth_server_policy_rule
# #################################################
variable "auth_policy_rule_name" {
  description = " Auth Server Policy Rule name. "
  type        = string
  default     = "policy_rule_for_token_inline"
}

# ##################################################

# ##########################################
# # ALB variables               #
# ##########################################
# variable "alb_tls_cert" {
#   description = "TLS Public Certificate. Value should be base64 encoded"
# }
# variable "alb_tls_cert_chain" {
#   description = "TLS Public Certificate Chain. Value should be base64 encoded"
# }
# variable "alb_tls_key" {
#   description = "TLS Private Key. Value should be base64 encoded"

# }

# ALB
# variable "name" {
#   type        = string
#   description = "The resource name and Name tag of the load balancer."
# }

variable "name_prefix" {
  type        = string
  description = "The resource name prefix and Name tag of the load balancer. Cannot be longer than 6 characters"
  default     = null

}

# variable "subnets" {
#   type = list(string)
#   description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
# }

# variable "vpc_id"{
#     type = string
#     description = "VPC id where the load balancer and other resources will be deployed"
# }

variable "alb_access_logs" {
  type        = map(string)
  description = "Map containing access logging configuration for load balancer."
  default     = {}
}

variable "alb_create_lb" {
  type        = bool
  description = "Controls if the Load Balancer should be created"

}

variable "alb_drop_invalid_header_fields" {
  type        = bool
  description = "Indicates whether invalid header fields are dropped in application load balancers. Defaults to false"


}

variable "alb_enable_cross_zone_load_balancing" {
  type        = bool
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."

}

variable "alb_enable_deletion_protection" {
  type        = bool
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false"
}

variable "alb_enable_http2" {
  type        = bool
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
}

variable "alb_extra_ssl_certs" {
  type        = list(map(string))
  description = "A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate_arn, https_listener_index (the index of the listener within https_listeners which the cert applies toward)"
  default     = []

}

variable "alb_http_tcp_listeners" {
  type        = any
  description = "A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])"
  default     = []
}

variable "alb_https_listener_rules" {
  type        = any
  description = "A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https_listener_index (default to https_listeners[count.index])"
  default     = []

}

variable "alb_https_listeners" {
  type        = any
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  default     = []
}

variable "alb_idle_timeout" {
  type        = number
  description = "The time in seconds that the connection is allowed to be idle."

}

variable "alb_internal" {
  type        = bool
  description = "Boolean determining if the load balancer is internal or externally facing"

}

variable "alb_ip_address_type" {
  type        = string
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
}

variable "alb_lb_tags" {
  type        = map(string)
  description = "A map of tags to add to load balancer"
  default     = {}

}

variable "alb_listener_ssl_policy_default" {
  type        = string
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html)"

}

variable "alb_load_balancer_create_timeout" {
  type        = string
  description = "Timeout value when creating the ALB."

}

variable "alb_load_balancer_delete_timeout" {
  type        = string
  description = "Timeout value when deleting the ALB."

}

variable "alb_load_balancer_type" {
  type        = string
  description = "The type of load balancer to create. Possible values are application or network"
  default     = "application"

}

variable "alb_security_groups" {
  type        = list(string)
  description = "The security groups to attach to the load balancer. e.g. ['sg-edcd9784','sg-edcd9785']"
  default     = []

}


variable "alb_tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "alb_target_group_tags" {
  type        = map(string)
  description = "A map of tags to add to all target groups"
  default     = {}

}

variable "alb_target_groups" {
  type        = any
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  default     = []
}

variable "alb_self_signed_cert_algorithm" {
  type    = string
  default = "RSA"
}

# variable "domain" {
#   type        = string
#   description = "SSL cert common name"
# }

variable "alb_self_signed_cert_validity_period_hours" {
  type        = number
  description = "cert expiry in hours"
}

variable "alb_tls_cert" {
  description = "TLS Public Certificate. Value should be base64 encoded"
}

variable "alb_tls_cert_chain" {
  description = "TLS Public Certificate Chain. Value should be base64 encoded"
}

variable "alb_tls_key" {
  description = "TLS Private Key. Value should be base64 encoded"

}


# wafv2
variable "waf_alb_arn" {
  description = "ARN of the ALB to be associated with the WAFv2 ACL."
  default     = ""
}

variable "waf_name" {
  type        = string
  description = "A friendly name of the WebACL"
}

variable "waf_scope" {
  type        = string
  default     = "REGIONAL"
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL."
}

variable "blacklisted_addresses" {
  description = "black listed IP addresses"
  default     = []
  type        = list(string)
}

variable "waf_associate_alb" {
  description = "Whether to associate an ALB with the WAFv2 ACL."
  type        = bool
  default     = true
}

variable "waf_filtered_header_rule" {
  description = "HTTP header to filter . Currently supports a single header type and multiple header values."
  type = object({
    header_types = list(string)
    priority     = number
    header_value = string
    action       = string
  })
  default = {
    "action" : "block",
    "header_types" : [],
    "header_value" : "",
    "priority" : 1
  }
}

variable "waf_group_rules" {
  description = "List of WAFv2 Rule Groups"
  type = list(object({
    name            = string
    arn             = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
  }))
  default = []
}

variable "waf_ip_rate_based_rule" {
  description = "A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span"
  type = object({
    name     = string
    priority = number
    limit    = number
    action   = string
  })
  default = null
}

variable "waf_ip_rate_url_based_rules" {
  description = "A rate and url based rules tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span"
  type = list(object({
    name                  = string
    priority              = number
    limit                 = number
    action                = string
    search_string         = string
    positional_constraint = string
  }))
  default = []
}

variable "waf_ip_sets_rule" {
  description = "A rule to detect web requests coming from particular IP addresses or address ranges."
  type = list(object({
    name       = string
    priority   = number
    ip_set_arn = string
    action     = string
  }))
  default = []
}

variable "waf_managed_rules" {
  description = "List of Managed WAF rules."
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
  }))

  default = [
    {
      "excluded_rules" : ["GenericRFI_BODY"],
      "name" : "AWSManagedRulesCommonRuleSet",
      "override_action" : "none",
      "priority" : 10
    },
    {
      "excluded_rules" : [],
      "name" : "AWSManagedRulesAmazonIpReputationList",
      "override_action" : "none",
      "priority" : 20
    },
    {
      "excluded_rules" : [],
      "name" : "AWSManagedRulesKnownBadInputsRuleSet",
      "override_action" : "none",
      "priority" : 30
    },
    {
      "excluded_rules" : [],
      "name" : "AWSManagedRulesSQLiRuleSet",
      "override_action" : "none",
      "priority" : 40
    },
    {
      "excluded_rules" : [],
      "name" : "AWSManagedRulesLinuxRuleSet",
      "override_action" : "none",
      "priority" : 50
    },
    {
      "excluded_rules" : [],
      "name" : "AWSManagedRulesUnixRuleSet",
      "override_action" : "none",
      "priority" : 60
    }
  ]
}


# iam refactor
variable "iam_create_role" {}
variable "iam_looker_email_role_name" {}
variable "role_requires_mfa" {}
variable "number_of_custom_role_policy_arns" {}
variable "iam_policy_name" {}
variable "iam_prometheus_password_reset_required" {}
variable "iam_prometheus_name" {}
variable "iam_user_force_destroy" {}
variable "looker_password_reset_required" {}
variable "iam_looker_name" {}
variable "looker_force_destroy" {}
variable "iam_looker_email_user_policy_arn" {}
variable "iam_looker_password_reset_required" {}
