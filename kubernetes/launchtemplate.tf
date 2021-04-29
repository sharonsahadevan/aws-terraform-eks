 data "template_file" "launch_template_userdata" {
   template = file("${path.module}/templates/userdata.sh.tpl")

  vars = {
    cluster_name        = var.cluster_name
    endpoint            = module.eks.cluster_endpoint
    cluster_auth_base64 = module.eks.cluster_certificate_authority_data

    bootstrap_extra_args = ""
    kubelet_extra_args   = ""
    additional_userdata  = ""
  }
}

# This is based on the LT that EKS would create if no custom one is specified (aws ec2 describe-launch-template-versions --launch-template-id xxx)
# there are several more options one could set but you probably dont need to modify them
# you can take the default and add your custom AMI and/or custom tags
#
# Trivia: AWS transparently creates a copy of your LaunchTemplate and actually uses that copy then for the node group. If you DONT use a custom AMI,
# then the default user-data for bootstrapping a cluster is merged in the copy.
resource "aws_launch_template" "default" {
  name_prefix            = "eks-example-"
  description            = "Default Launch-Template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.nodegroup_volume_size  // 100 
      volume_type           = var.nodegroup_volume_type // "gp2"
      delete_on_termination = var.nodegroup_ebs_delete_on_termination // true
      #encrypted             = true

      # Enable this if you want to encrypt your node root volumes with a KMS/CMK. encryption of PVCs is handled via k8s StorageClass tho
      # you also need to attach data.aws_iam_policy_document.ebs_decryption.json from the disk_encryption_policy.tf to the KMS/CMK key then !!
       #kms_key_id            = var.kms_key_arn
    }
  }

  #instance_type = "t3.small"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [module.eks.worker_security_group_id]
  }

  # if you want to use a custom AMI
  # image_id      = var.ami_id

  # If you use a custom AMI, you need to supply via user-data, the bootstrap script as EKS DOESNT merge its managed user-data then
  # you can add more than the minimum code you see in the template, e.g. install SSM agent, see https://github.com/aws/containers-roadmap/issues/593#issuecomment-577181345
  #
  # (optionally you can use https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config to render the script, example: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/997#issuecomment-705286151)

  # user_data = base64encode(
  #   data.template_file.launch_template_userdata.rendered,
  # )


  # Supplying custom tags to EKS instances is another use-case for LaunchTemplates
  tag_specifications {
    resource_type = "instance"

    tags = {
      CustomTag = "EKS example"
    }

    # tags = {
    #       "Organization" = "REDSEAL Inc",
    #       "Stack"        = "dev"
    #       "Name"         = "shared-services-${var.stack}"
    # }
  }

  # Supplying custom tags to EKS instances root volumes is another use-case for LaunchTemplates. (doesnt add tags to dynamically provisioned volumes via PVC tho)
  tag_specifications {
    resource_type = "volume"

    tags = {
      CustomTag = "EKS example"
    }

        # tags = {
    #       "Organization" = "REDSEAL Inc",
    #       "Stack"        = "dev"
    #       "Name"         = "shared-services-${var.stack}"
    # }
  }

  # Tag the LT itself
  # tags = {
  #   CustomTag = "EKS example"
  # }

      tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        =  var.stack_name
          "Name"         = "shared-services-${var.stack_name}"
    }

  lifecycle {
    create_before_destroy = true
  }
}


# tenant service launch template
resource "aws_launch_template" "tenant_tmpl" {
  name_prefix            = "eks-tenant-services"
  description            = "tenant services launch template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.tenant_nodegroup_volume_size  // 100 
      volume_type           = var.tenant_nodegroup_volume_type // "gp2"
      delete_on_termination = var.tenant_nodegroup_ebs_delete_on_termination // true
       #encrypted             = true
       #kms_key_id            = "arn:aws:kms:us-west-2:633110707374:key/0c7557fc-37f5-4bf6-b754-5ee13545f3fb"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  #instance_type = var.tenant_instant_type

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [module.eks.worker_security_group_id]
  }

  # if you want to use a custom AMI
  # image_id      = var.ami_id

  # user_data = base64encode(
  #   data.template_file.launch_template_userdata.rendered,
  # )


  # Supplying custom tags to EKS instances is another use-case for LaunchTemplates
  tag_specifications {
    resource_type = "instance"

    # tags = {
    #   CustomTag = "EKS example"
    # }



    tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "tenant-services-${var.stack_name}"
    }



  }

  # Supplying custom tags to EKS instances root volumes is another use-case for LaunchTemplates. (doesnt add tags to dynamically provisioned volumes via PVC tho)
  tag_specifications {
    resource_type = "volume"

    # tags = {
    #   CustomTag = "EKS example"
    # }

        tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "tenant-services-${var.stack_name}"
    }
  }

  # Tag the LT itself
  # tags = {
  #   CustomTag = "EKS example"
  # }

      tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "tenant-services-${var.stack_name}"
    }

  lifecycle {
    create_before_destroy = true
  }
}


# observability
resource "aws_launch_template" "observability_tmpl" {
  name_prefix            = "eks-observability-"
  description            = "observability launch template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.observability_nodegroup_volume_size  // 100 
      volume_type           = var.observability_nodegroup_volume_type // "gp2"
      delete_on_termination = var.observability_nodegroup_ebs_delete_on_termination // true
       #encrypted             = true
       #kms_key_id            = "arn:aws:kms:us-west-2:633110707374:key/0c7557fc-37f5-4bf6-b754-5ee13545f3fb"
    }
  }

    metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  #instance_type = var.tenant_instant_type

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [module.eks.worker_security_group_id]
  }

  # if you want to use a custom AMI
  # image_id      = var.ami_id

  # user_data = base64encode(
  #   data.template_file.launch_template_userdata.rendered,
  # )


  # Supplying custom tags to EKS instances is another use-case for LaunchTemplates
  tag_specifications {
    resource_type = "instance"

    # tags = {
    #   CustomTag = "EKS example"
    # }

    tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "observability-${var.stack_name}"
    }
  }

  # Supplying custom tags to EKS instances root volumes is another use-case for LaunchTemplates. (doesnt add tags to dynamically provisioned volumes via PVC tho)
  tag_specifications {
    resource_type = "volume"

    # tags = {
    #   CustomTag = "EKS example"
    # }

        tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "observability-${var.stack_name}"
    }
  }

  # Tag the LT itself
  # tags = {
  #   CustomTag = "EKS example"
  # }

      tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "observability-${var.stack_name}"
    }

  lifecycle {
    create_before_destroy = true
  }
}

# shared services
resource "aws_launch_template" "shared_services_tmpl" {
  name_prefix            = "eks-shared-services"
  description            = "shared-services launch template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.shared_services_nodegroup_volume_size  // 100 
      volume_type           = var.shared_services_nodegroup_volume_type // "gp2"
      delete_on_termination = var.shared_services_nodegroup_ebs_delete_on_termination // true
       #encrypted             = true
       #kms_key_id            = "arn:aws:kms:us-west-2:633110707374:key/0c7557fc-37f5-4bf6-b754-5ee13545f3fb"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  #instance_type = var.tenant_instant_type

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [module.eks.worker_security_group_id]
  }

  # if you want to use a custom AMI
  # image_id      = var.ami_id

  # user_data = base64encode(
  #   data.template_file.launch_template_userdata.rendered,
  # )


  # Supplying custom tags to EKS instances is another use-case for LaunchTemplates
  tag_specifications {
    resource_type = "instance"

    # tags = {
    #   CustomTag = "EKS example"
    # }

    tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "shared-services-${var.stack_name}"
    }
  }

  # Supplying custom tags to EKS instances root volumes is another use-case for LaunchTemplates. (doesnt add tags to dynamically provisioned volumes via PVC tho)
  tag_specifications {
    resource_type = "volume"

    # tags = {
    #   CustomTag = "EKS example"
    # }

        tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "shared-services-${var.stack_name}"
    }
  }

  # Tag the LT itself
  # tags = {
  #   CustomTag = "EKS example"
  # }

      tags = {
          "Organization" = "REDSEAL Inc",
          "Stack"        = var.stack_name
          "Name"         = "shared-services-${var.stack_name}"
    }

  lifecycle {
    create_before_destroy = true
  }
}