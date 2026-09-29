################################################################################
# Imagebuilder Component
################################################################################

resource "aws_imagebuilder_component" "this" {
  for_each = var.create_components ? { for comp in var.components : comp.name => comp } : {}

  name                  = each.value.name
  platform              = each.value.platform
  version               = each.value.version
  description           = try(each.value.description, null)
  change_description    = try(each.value.change_description, null)
  kms_key_id            = try(each.value.kms_key_id != "" ? each.value.kms_key_id : null, null)
  supported_os_versions = try(each.value.supported_os_versions, [])
  skip_destroy          = try(each.value.skip_destroy, false)
  tags                  = try(each.value.tags, {})

data = try(each.value.use_inline_component, false) ? join("\n", flatten(concat([
  [
    "name: ${each.value.name}",
    "description: ${try(each.value.description, "")}",
    "schemaVersion: 1.0",
    ""
  ],
  length(try(each.value.parameters, [])) > 0 ? concat(
    ["parameters:"],
    flatten([
      for param in each.value.parameters : concat(
        ["  - ${param.name}:"],
        ["      type: ${param.type}"],
        param.default != null ? ["      default: \"${param.default}\""] : [],
        ["      description: ${param.description}"],
        param.allowedValues != null ? concat(
          ["      allowedValues:"],
          [for val in param.allowedValues : "        - ${val}"]
        ) : []
      )
    ])
  ) : [],
  [""],
  ["phases:"],
  flatten([
    for phase in try(each.value.phases, []) : concat([
      [
        "  - name: ${phase.name}",
        "    steps:"
      ],
      flatten([
        for step in try(phase.steps, []) : concat([
          [
            "      - name: ${step.name}",
            "        action: ${step.action}",
            "        inputs:",
            "          commands:",
          ],
          [for command in try(step.inputs, []) : "            - ${command}"],
          [""]
        ])
      ])
    ])
  ]),
  [""]
]))) : null


  uri = try(each.value.uri != "" ? each.value.uri : null, null)
}




################################################################################
# Image Recipe
################################################################################

resource "aws_imagebuilder_image_recipe" "this" {
  for_each = {
    for recipe in var.image_recipes : recipe.name => recipe
    if var.create_image_recipe
  }

  name         = each.value.name
  parent_image = each.value.parent_image
  version      = each.value.version
  description  = lookup(each.value, "description", null)
  working_directory = lookup(each.value, "working_directory", null)
  user_data_base64  = lookup(each.value, "user_data_base64", null)

  dynamic "block_device_mapping" {
    for_each = lookup(each.value, "block_device_mapping", [])
    content {
      device_name = block_device_mapping.value.device_name

      dynamic "ebs" {
        for_each = block_device_mapping.value.ebs[*]
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          iops                  = lookup(ebs.value, "iops", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          throughput            = lookup(ebs.value, "throughput", null)
        }
      }

      no_device     = lookup(block_device_mapping.value, "no_device", null)
      virtual_name  = lookup(block_device_mapping.value, "virtual_name", null)
    }
  }

  dynamic "component" {
    for_each = each.value.component
    content {
      component_arn = component.value.component_arn

      dynamic "parameter" {
        for_each = lookup(component.value, "parameter", [])
        content {
          name  = parameter.value.name
          value = parameter.value.value
        }
      }
    }
  }

  dynamic "systems_manager_agent" {
    for_each = lookup(each.value, "systems_manager_agent", []) == [] ? [] : [1]
    content {
      uninstall_after_build = each.value.systems_manager_agent.uninstall_after_build
    }
  }

  tags = lookup(each.value, "tags", null)
}


################################################################################
# Container Recipe
################################################################################

resource "aws_imagebuilder_container_recipe" "this" {
  for_each = var.create_container_recipes ? { for rec in var.container_recipes : rec.name => rec } : {}

  name           = each.value.name
  version        = each.value.version
  container_type = each.value.container_type
  parent_image   = each.value.parent_image

  description              = try(each.value.description, null)
  dockerfile_template_data = try(each.value.dockerfile_template_data, null)
  dockerfile_template_uri  = try(each.value.dockerfile_template_uri, null)
  kms_key_id               = try(each.value.kms_key_id, null)
  platform_override        = try(each.value.platform_override, null)
  working_directory        = try(each.value.working_directory, null)
  tags                     = try(each.value.tags, {})

  target_repository {
    repository_name = each.value.target_repository.repository_name
    service         = each.value.target_repository.service
  }

  dynamic "component" {
    for_each = each.value.components
    content {
      component_arn = component.value.component_arn

      dynamic "parameter" {
        for_each = try(component.value.parameter, [])
        content {
          name  = parameter.value.name
          value = parameter.value.value
        }
      }
    }
  }

  dynamic "instance_configuration" {
    for_each = try(each.value.instance_configuration, null) != null ? [each.value.instance_configuration] : []
    content {
      image = try(each.value.instance_configuration.image, null)

      dynamic "block_device_mapping" {
        for_each = try(each.value.instance_configuration.block_device_mapping, [])
        content {
          device_name  = try(block_device_mapping.value.device_name, null)
          no_device    = try(block_device_mapping.value.no_device, null)
          virtual_name = try(block_device_mapping.value.virtual_name, null)

          dynamic "ebs" {
            for_each = try(block_device_mapping.value.ebs != null ? block_device_mapping.value.ebs : [], [])
            content {
              delete_on_termination = try(ebs.value.delete_on_termination, null)
              encrypted             = try(ebs.value.encrypted, null)
              iops                  = try(ebs.value.iops, null)
              kms_key_id            = try(ebs.value.kms_key_id, null)
              snapshot_id           = try(ebs.value.snapshot_id, null)
              throughput            = try(ebs.value.throughput, null)
              volume_size           = try(ebs.value.volume_size, null)
              volume_type           = try(ebs.value.volume_type, null)
            }
          }
        }
      }
    }
  }
}


################################################################################
# infrastructure configuration
################################################################################

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  count = var.create_infrastructure_configurations ? length(var.infrastructure_configurations) : 0

  name                  = var.infrastructure_configurations[count.index].name
  instance_profile_name = var.infrastructure_configurations[count.index].instance_profile_name

  description           = try(var.infrastructure_configurations[count.index].description, null)
  instance_types        = try(var.infrastructure_configurations[count.index].instance_types, null)
  key_pair              = try(var.infrastructure_configurations[count.index].key_pair, null)
  security_group_ids    = try(var.infrastructure_configurations[count.index].security_group_ids, null)
  sns_topic_arn         = try(var.infrastructure_configurations[count.index].sns_topic_arn, null)
  subnet_id             = try(var.infrastructure_configurations[count.index].subnet_id, null)
  terminate_instance_on_failure = try(var.infrastructure_configurations[count.index].terminate_instance_on_failure, false)

  logging {
    s3_logs {
      s3_bucket_name = var.infrastructure_configurations[count.index].logging.s3_logs.s3_bucket_name
      s3_key_prefix  = try(var.infrastructure_configurations[count.index].logging.s3_logs.s3_key_prefix, "/")
    }
  }

  instance_metadata_options {
    http_put_response_hop_limit = try(var.infrastructure_configurations[count.index].instance_metadata_options.http_put_response_hop_limit, null)
    http_tokens                 = try(var.infrastructure_configurations[count.index].instance_metadata_options.http_tokens, null)
  }

  resource_tags = try(var.infrastructure_configurations[count.index].resource_tags, null)
  tags          = try(var.infrastructure_configurations[count.index].tags, null)
}



################################################################################
# Distribution Configuration 
################################################################################

resource "aws_imagebuilder_distribution_configuration" "this" {
  count = var.create_distribution_configurations ? length(var.distribution_configurations) : 0

  name        = var.distribution_configurations[count.index].name
  description = try(var.distribution_configurations[count.index].description, null)
  tags        = try(var.distribution_configurations[count.index].tags, null)

  dynamic "distribution" {
    for_each = var.distribution_configurations[count.index].distributions
    content {
      region = distribution.value.region

      # Optional: License Configuration ARNs
      license_configuration_arns = try(distribution.value.license_configuration_arns, null)

      # AMI Distribution Block
      dynamic "ami_distribution_configuration" {
        for_each = distribution.value.ami_distribution_configuration != null ? [distribution.value.ami_distribution_configuration] : []
        content {
          ami_tags            = try(ami_distribution_configuration.value.ami_tags, null)
          description         = try(ami_distribution_configuration.value.description, null)
          kms_key_id          = try(ami_distribution_configuration.value.kms_key_id, null)
          name                = try(ami_distribution_configuration.value.name, null)
          target_account_ids  = try(ami_distribution_configuration.value.target_account_ids, null)

          dynamic "launch_permission" {
            for_each = try(ami_distribution_configuration.value.launch_permission != null, false) ? [ami_distribution_configuration.value.launch_permission] : []
            content {
              organization_arns        = try(launch_permission.value.organization_arns, null)
              organizational_unit_arns = try(launch_permission.value.organizational_unit_arns, null)
              user_groups              = try(launch_permission.value.user_groups, null)
              user_ids                 = try(launch_permission.value.user_ids, null)
            }
          }
        }
      }

      # Container Distribution Block
      dynamic "container_distribution_configuration" {
        for_each = distribution.value.container_distribution_configuration != null ? [distribution.value.container_distribution_configuration] : []
        content {
          container_tags = try(container_distribution_configuration.value.container_tags, null)
          description    = try(container_distribution_configuration.value.description, null)

          target_repository {
            repository_name = container_distribution_configuration.value.target_repository.repository_name
            service         = container_distribution_configuration.value.target_repository.service
          }
        }
      }

      # Fast Launch Block
      dynamic "fast_launch_configuration" {
        for_each = distribution.value.fast_launch_configuration != null ? [distribution.value.fast_launch_configuration] : []
        content {
          account_id            = fast_launch_configuration.value.account_id
          enabled               = fast_launch_configuration.value.enabled
          max_parallel_launches = try(fast_launch_configuration.value.max_parallel_launches, null)

          dynamic "launch_template" {
            for_each = try(fast_launch_configuration.value.launch_template != null, false) ? [fast_launch_configuration.value.launch_template] : []
            content {
              launch_template_id      = try(launch_template.value.launch_template_id, null)
              launch_template_name    = try(launch_template.value.launch_template_name, null)
              launch_template_version = try(launch_template.value.launch_template_version, null)
            }
          }

          dynamic "snapshot_configuration" {
            for_each = try(fast_launch_configuration.value.snapshot_configuration != null, false) ? [fast_launch_configuration.value.snapshot_configuration] : []
            content {
              target_resource_count = snapshot_configuration.value.target_resource_count
            }
          }
        }
      }

      # Launch Template Configuration Block
      dynamic "launch_template_configuration" {
        for_each = distribution.value.launch_template_configuration != null ? [distribution.value.launch_template_configuration] : []
        content {
          default            = try(launch_template_configuration.value.default, true)
          account_id         = try(launch_template_configuration.value.account_id, null)
          launch_template_id = launch_template_configuration.value.launch_template_id
        }
      }

      # S3 Export Block
      dynamic "s3_export_configuration" {
        for_each = distribution.value.s3_export_configuration != null ? [distribution.value.s3_export_configuration] : []
        content {
          disk_image_format = s3_export_configuration.value.disk_image_format
          role_name         = s3_export_configuration.value.role_name
          s3_bucket         = s3_export_configuration.value.s3_bucket
          s3_prefix         = try(s3_export_configuration.value.s3_prefix, null)
        }
      }
    }
  }
}



################################################################################
# Imagebuilder workflow
################################################################################


resource "aws_imagebuilder_workflow" "this" {
  count = var.create_workflows ? length(var.workflows) : 0

  name    = var.workflows[count.index].name
  version = var.workflows[count.index].version
  type    = var.workflows[count.index].type

  change_description = try(var.workflows[count.index].change_description, null)
  data               = try(var.workflows[count.index].data, null)
  description        = try(var.workflows[count.index].description, null)
  kms_key_id         = try(var.workflows[count.index].kms_key_id, null)
  tags               = try(var.workflows[count.index].tags, null)
  uri                = try(var.workflows[count.index].uri, null)
}

################################################################################
# Data Sources
################################################################################

data "aws_region" "current" {}

data "aws_partition" "current" {}

################################################################################
# IAM Role Creation (conditionally used)
################################################################################

resource "aws_iam_role" "imagebuilder" {
  count = var.enable_lifecycle_policy_creation && anytrue([
    for policy in var.workflows_lifecycle_policies : policy.execution_role == null || policy.execution_role == ""
  ]) ? 1 : 0

  name = "imagebuilder-lifecycle-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "imagebuilder.${data.aws_partition.current.dns_suffix}"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "imagebuilder" {
  count = length(aws_iam_role.imagebuilder)

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/EC2ImageBuilderLifecycleExecutionPolicy"
  role       = aws_iam_role.imagebuilder[0].name
}

################################################################################
# Image Builder Lifecycle Policy
################################################################################

resource "aws_imagebuilder_lifecycle_policy" "this" {
  count = var.enable_lifecycle_policy_creation ? length(var.workflows_lifecycle_policies) : 0

  name           = var.workflows_lifecycle_policies[count.index].name
  description    = try(var.workflows_lifecycle_policies[count.index].description, null)
  resource_type  = var.workflows_lifecycle_policies[count.index].resource_type
  execution_role = (
    var.workflows_lifecycle_policies[count.index].execution_role != null &&
    var.workflows_lifecycle_policies[count.index].execution_role != ""
  ) ? var.workflows_lifecycle_policies[count.index].execution_role : aws_iam_role.imagebuilder[0].arn

  tags = try(var.workflows_lifecycle_policies[count.index].tags, null)

  policy_detail {
    action {
      type = var.workflows_lifecycle_policies[count.index].policy_detail.action.type

      dynamic "include_resources" {
        for_each = try([var.workflows_lifecycle_policies[count.index].policy_detail.action.include_resources], [])
        content {
          amis      = try(include_resources.value.amis, null)
          containers = try(include_resources.value.containers, null)
          snapshots  = try(include_resources.value.snapshots, null)
        }
      }
    }

    filter {
      type            = var.workflows_lifecycle_policies[count.index].policy_detail.filter.type
      value           = var.workflows_lifecycle_policies[count.index].policy_detail.filter.value
      retain_at_least = try(var.workflows_lifecycle_policies[count.index].policy_detail.filter.retain_at_least, null)
      unit            = try(var.workflows_lifecycle_policies[count.index].policy_detail.filter.unit, null)
    }

    dynamic "exclusion_rules" {
      for_each = try([var.workflows_lifecycle_policies[count.index].policy_detail.exclusion_rules], [])
      content {
        dynamic "amis" {
          for_each = try([exclusion_rules.value.amis], [])
          content {
            is_public       = try(amis.value.is_public, null)
            regions         = try(amis.value.regions, null)
            shared_accounts = try(amis.value.shared_accounts, null)
            tag_map         = try(amis.value.tag_map, null)

            dynamic "last_launched" {
              for_each = try([amis.value.last_launched], [])
              content {
                unit  = last_launched.value.unit
                value = last_launched.value.value
              }
            }
          }
        }

        tag_map = try(exclusion_rules.value.tag_map, null)
      }
    }
  }

  resource_selection {
    tag_map = try(
      var.workflows_lifecycle_policies[count.index].resource_selection.recipe == null
        ? var.workflows_lifecycle_policies[count.index].resource_selection.tag_map
        : null,
      null
    )

    dynamic "recipe" {
      for_each = try(
        var.workflows_lifecycle_policies[count.index].resource_selection.recipe != null
          ? var.workflows_lifecycle_policies[count.index].resource_selection.recipe
          : [],
        []
      )
      content {
        name             = recipe.value.name
        semantic_version = recipe.value.semantic_version
      }
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.imagebuilder
  ]
}


################################################################################
# Image
################################################################################


resource "aws_imagebuilder_image" "this" {
  count = var.enable_imagebuilder_image_creation ? length(var.imagebuilder_images) : 0

  infrastructure_configuration_arn = var.imagebuilder_images[count.index].infrastructure_configuration_arn

  container_recipe_arn             = try(var.imagebuilder_images[count.index].container_recipe_arn, null)
  distribution_configuration_arn   = try(var.imagebuilder_images[count.index].distribution_configuration_arn, null)
  enhanced_image_metadata_enabled  = try(var.imagebuilder_images[count.index].enhanced_image_metadata_enabled, true)
  execution_role                   = try(var.imagebuilder_images[count.index].execution_role, null)
  image_recipe_arn                 = try(var.imagebuilder_images[count.index].image_recipe_arn, null)
  tags                             = try(var.imagebuilder_images[count.index].tags, null)

  dynamic "image_tests_configuration" {
    for_each = try([var.imagebuilder_images[count.index].image_tests_configuration], [])
    content {
      image_tests_enabled = try(image_tests_configuration.value.image_tests_enabled, true)
      timeout_minutes     = try(image_tests_configuration.value.timeout_minutes, 720)
    }
  }

  dynamic "image_scanning_configuration" {
    for_each = try([var.imagebuilder_images[count.index].image_scanning_configuration], [])
    content {
      image_scanning_enabled = try(image_scanning_configuration.value.image_scanning_enabled, false)

      dynamic "ecr_configuration" {
        for_each = try([image_scanning_configuration.value.ecr_configuration], [])
        content {
          repository_name = try(ecr_configuration.value.repository_name, null)
          container_tags  = try(ecr_configuration.value.container_tags, null)
        }
      }
    }
  }

  dynamic "workflow" {
    for_each = try([var.imagebuilder_images[count.index].workflow], [])
    content {
      workflow_arn = workflow.value.workflow_arn
      on_failure   = try(workflow.value.on_failure, null)
      parallel_group = try(workflow.value.parallel_group, null)

      dynamic "parameter" {
        for_each = try(workflow.value.parameter, [])
        content {
          name  = parameter.value.name
          value = parameter.value.value
        }
      }
    }
  }
}

################################################################################
# Image Pipeline
################################################################################

resource "aws_imagebuilder_image_pipeline" "this" {
  count = var.create_image_pipeline ? 1 : 0

  name                              = var.pipeline_config.pipeline_name
  infrastructure_configuration_arn  = var.pipeline_config.infrastructure_configuration_arn
  description                       = var.pipeline_config.pipeline_description
  distribution_configuration_arn    = var.pipeline_config.distribution_configuration_arn
  enhanced_image_metadata_enabled   = var.pipeline_config.enhanced_image_metadata_enabled
  execution_role                    = var.pipeline_config.execution_role_arn
  status                            = var.pipeline_config.pipeline_status
  tags                              = var.pipeline_config.tags

  image_recipe_arn     = var.pipeline_config.image_recipe_arn
  container_recipe_arn = var.pipeline_config.container_recipe_arn

  // Optional: Image Tests Configuration
  dynamic "image_tests_configuration" {
    for_each = var.pipeline_config.image_tests_enabled ? [1] : []
    content {
      image_tests_enabled = var.pipeline_config.image_tests_enabled
      timeout_minutes     = var.pipeline_config.image_tests_timeout_minutes
    }
  }

  // Optional: Image Scanning Configuration
  dynamic "image_scanning_configuration" {
    for_each = var.pipeline_config.image_scanning_enabled ? [1] : []
    content {
      image_scanning_enabled = var.pipeline_config.image_scanning_enabled
      ecr_configuration {
        repository_name = var.pipeline_config.ecr_repository_name
        container_tags  = var.pipeline_config.ecr_container_tags
      }
    }
  }

  // Optional: Schedule Configuration
  schedule {
    schedule_expression                = var.pipeline_config.schedule_expression
    pipeline_execution_start_condition = var.pipeline_config.pipeline_execution_start_condition
    timezone                           = var.pipeline_config.schedule_timezone
  }

  // Optional: Multiple Workflow Blocks (Build + Test)
  dynamic "workflow" {
    for_each = length(var.pipeline_config.pipeline_workflows) > 0 ? var.pipeline_config.pipeline_workflows : []
    content {
      workflow_arn   = workflow.value.workflow_arn
      on_failure     = workflow.value.on_failure
      parallel_group = workflow.value.type == "test" ? workflow.value.parallel_group : null

      dynamic "parameter" {
        for_each = workflow.value.parameters != null ? workflow.value.parameters : []
        content {
          name  = parameter.value.name
          value = parameter.value.value
        }
      }
    }
  }
}
