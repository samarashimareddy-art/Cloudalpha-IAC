
################################################################################
# Image Recipe Variable
################################################################################

variable "create_image_recipe" {
  description = "Whether to create the aws_imagebuilder_image_recipe resource"
  type        = bool
  default     = false
}


variable "image_recipes" {
  description = "List of image recipe definitions"
  type = list(object({
    name         = string
    parent_image = string
    version      = string
    description  = optional(string)
    working_directory = optional(string)
    user_data_base64  = optional(string)
    tags              = optional(map(string))

    block_device_mapping = optional(list(object({
      device_name = string
      ebs = optional(list(object({
        delete_on_termination = optional(bool)
        volume_size           = optional(number)
        volume_type           = optional(string)
        encrypted             = optional(bool)
        iops                  = optional(number)
        kms_key_id            = optional(string)
        snapshot_id           = optional(string)
        throughput            = optional(number)
      })))
      no_device    = optional(bool)
      virtual_name = optional(string)
    })))

    component = list(object({
      component_arn = string
      parameter     = optional(list(object({
        name  = string
        value = string
      })))
    }))

    systems_manager_agent = optional(object({
      uninstall_after_build = bool
    }))
  }))
}


################################################################################
# Container Recipe Variable
################################################################################

variable "create_container_recipes" {
  description = "Flag to create container recipes"
  type        = bool
  default     = true
}

variable "container_recipes" {
  description = "List of container recipe configurations"
  type = list(object({
    name           = string
    version        = string
    container_type = string
    parent_image   = string

    description              = optional(string)
    dockerfile_template_data = optional(string)
    dockerfile_template_uri  = optional(string)
    kms_key_id               = optional(string)
    platform_override        = optional(string)
    working_directory        = optional(string)
    tags                     = optional(map(string))

    target_repository = object({
      repository_name = string
      service         = string
    })

    components = list(object({
      component_arn = string
      parameter     = optional(list(object({
        name  = string
        value = string
      })))
    }))

    instance_configuration = optional(object({
      image = optional(string)
      block_device_mapping = optional(list(object({
        device_name  = optional(string)
        no_device    = optional(bool)
        virtual_name = optional(string)
        ebs = optional(list(object({
          delete_on_termination = optional(bool)
          encrypted             = optional(bool)
          iops                  = optional(number)
          kms_key_id            = optional(string)
          snapshot_id           = optional(string)
          throughput            = optional(number)
          volume_size           = optional(number)
          volume_type           = optional(string)
        })))
      })))
    }))
  }))
  default = []
}





################################################################################
# Imagebuilder Component Variables
################################################################################

variable "create_components" {
  description = "Flag to create components"
  type        = bool
  default     = true
}

variable "components" {
  description = "List of components to be created"
  type = list(object({
    name                   = string
    platform               = string
    version                = string
    description            = optional(string)
    change_description     = optional(string)
    kms_key_id             = optional(string)
    supported_os_versions  = optional(list(string))
    skip_destroy           = optional(bool)
    tags                   = optional(map(string))
    use_inline_component   = bool
    uri                    = optional(string)

    # New: Optional Parameters block
    parameters = optional(list(object({
      name          = string
      description   = string
      type          = string
      default       = optional(string)
      allowedValues = optional(list(string))
    })))

    # Required: Phases block
    phases = list(object({
      name  = string
      steps = list(object({
        name   = string
        action = string
        inputs = list(string)
      }))
    }))
  }))
  default = []
}



################################################################################
# Infrastructure Configuration Variables
################################################################################

variable "create_infrastructure_configurations" {
  description = "Flag to create infrastructure configurations"
  type        = bool
  default     = true
}

variable "infrastructure_configurations" {
  description = "List of Image Builder Infrastructure Configurations"
  type = list(object({
    name                  = string
    instance_profile_name = string
    description           = optional(string)
    instance_types        = optional(list(string))
    key_pair              = optional(string)
    security_group_ids    = optional(list(string))
    sns_topic_arn         = optional(string)
    subnet_id             = optional(string)
    terminate_instance_on_failure = optional(bool, false)
    resource_tags         = optional(map(string))
    tags                  = optional(map(string))

    instance_metadata_options = optional(object({
      http_put_response_hop_limit = optional(number)
      http_tokens                 = optional(string)
    }))

    logging = optional(object({
      s3_logs = object({
        s3_bucket_name = string
        s3_key_prefix  = optional(string, "/")
      })
    }))
  }))
  default = []
}


################################################################################
# Distribution Configuration Variables
################################################################################

variable "create_distribution_configurations" {
  description = "Control whether distribution configuration is created"
  type        = bool
  default     = false
}

variable "distribution_configurations" {
  description = "List of distribution configuration definitions"
  type = list(object({
    name        = string
    description = optional(string)
    tags        = optional(map(string))

    distributions = list(object({
      region                     = string
      license_configuration_arns = optional(list(string)) # <-- Added support

      ami_distribution_configuration = optional(object({
        ami_tags           = optional(map(string))
        description        = optional(string)
        kms_key_id         = optional(string)
        name               = optional(string)
        target_account_ids = optional(list(string))

        launch_permission = optional(object({
          organization_arns        = optional(list(string))
          organizational_unit_arns = optional(list(string))
          user_groups              = optional(list(string))
          user_ids                 = optional(list(string))
        }))
      }))

      container_distribution_configuration = optional(object({
        container_tags = optional(list(string))
        description    = optional(string)

        target_repository = object({
          repository_name = string
          service         = string
        })
      }))

      fast_launch_configuration = optional(object({
        account_id            = string
        enabled               = bool
        max_parallel_launches = optional(number)

        launch_template = optional(object({
          launch_template_id      = optional(string)
          launch_template_name    = optional(string)
          launch_template_version = optional(string)
        }))

        snapshot_configuration = optional(object({
          target_resource_count = number
        }))
      }))

      launch_template_configuration = optional(object({
        default            = optional(bool)
        account_id         = optional(string)
        launch_template_id = string
      }))

      s3_export_configuration = optional(object({
        disk_image_format = string
        role_name         = string
        s3_bucket         = string
        s3_prefix         = optional(string)
      }))
    }))
  }))
}

################################################################################
# Workflow Variables
################################################################################

variable "create_workflows" {
  description = "Control whether workflows are created"
  type        = bool
  default     = true
}

variable "workflows" {
  description = "List of Image Builder Workflow configurations"
  type = list(object({
    name              = string
    version           = string
    type              = string  // Valid values: BUILD, TEST (DISTRIBUTION workflows are not allowed)
    change_description = optional(string)
    data              = optional(string) // Inline YAML data for the workflow
    description       = optional(string)
    kms_key_id        = optional(string)
    tags              = optional(map(string))
    uri               = optional(string)
  }))
  default = []
}


################################################################################
# Lifecycle Variables
################################################################################

variable "enable_lifecycle_policy_creation" {
  description = "Flag to enable/disable lifecycle policy creation"
  type        = bool
  default     = false
}

variable "workflows_lifecycle_policies" {
  description = "List of lifecycle policies to create"
  type = list(object({
    name           = string
    description    = optional(string)
    resource_type  = string
    execution_role = optional(string) # Optional for dynamic IAM role usage
    tags           = optional(map(string))

    policy_detail = object({
      action = object({
        type = string
        include_resources = optional(object({
          amis      = optional(bool)
          containers = optional(bool)
          snapshots  = optional(bool)
        }))
      })

      filter = object({
        type            = string
        value           = number
        retain_at_least = optional(number)
        unit            = optional(string)
      })

    exclusion_rules = optional(list(object({
      amis = object({
        is_public       = optional(bool)
        regions         = optional(list(string))
        shared_accounts = optional(list(string))
        tag_map         = optional(map(string))
        last_launched   = optional(object({
          unit  = string
          value = number
        }))
      })
      tag_map = optional(map(string)) # If included
    })))

    })

    resource_selection = object({
      tag_map = optional(map(string))
      recipe = optional(list(object({
        name             = string
        semantic_version = string
      })))
    })
  }))
  default = []
}


################################################################################
# Image Variable
################################################################################

variable "enable_imagebuilder_image_creation" {
  description = "Enable or disable aws_imagebuilder_image resource creation"
  type        = bool
  default     = false
}

variable "imagebuilder_images" {
  description = "List of imagebuilder image configurations"
  type = list(object({
    infrastructure_configuration_arn = string
    container_recipe_arn             = optional(string)
    distribution_configuration_arn   = optional(string)
    enhanced_image_metadata_enabled  = optional(bool)
    execution_role                   = optional(string)
    image_recipe_arn                 = optional(string)
    tags                             = optional(map(string))

    image_tests_configuration = optional(object({
      image_tests_enabled = optional(bool)
      timeout_minutes     = optional(number)
    }))

    image_scanning_configuration = optional(object({
      image_scanning_enabled = optional(bool)
      ecr_configuration = optional(object({
        repository_name = optional(string)
        container_tags  = optional(list(string))
      }))
    }))

    workflow = optional(object({
      workflow_arn   = string
      on_failure     = optional(string)
      parallel_group = optional(string)
      parameter = optional(list(object({
        name  = string
        value = string
      })))
    }))
  }))
}





################################################################################
# Image-Pipeline Variable
################################################################################

variable "create_image_pipeline" {
  description = "Flag to conditionally create the Image Builder pipeline."
  type        = bool
  default     = true
}

variable "pipeline_config" {
  description = "Configuration for the Image Builder pipeline."
  type = object({
    # Required attributes
    pipeline_name                      = string
    infrastructure_configuration_arn   = string
    schedule_expression                = string

    # Optional attributes
    pipeline_description               = optional(string)
    distribution_configuration_arn     = optional(string)
    enhanced_image_metadata_enabled    = optional(bool, true)
    execution_role_arn                 = optional(string)
    pipeline_status                    = optional(string, "ENABLED")
    tags                               = optional(map(string), {})

    image_recipe_arn                   = optional(string)
    container_recipe_arn               = optional(string)

    image_tests_enabled                = optional(bool, true)
    image_tests_timeout_minutes        = optional(number, 720)

    image_scanning_enabled             = optional(bool, false)
    ecr_repository_name                = optional(string)
    ecr_container_tags                 = optional(list(string), [])

    pipeline_execution_start_condition = optional(string, "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE")
    schedule_timezone                  = optional(string, "Etc/UTC")

    pipeline_workflows = optional(list(object({
      workflow_arn   = string
      type           = string         // "build" or "test"
      on_failure     = optional(string)
      parallel_group = optional(string)
      parameters = optional(list(object({
        name  = string
        value = string
      })))
    })), [])
  })
}

