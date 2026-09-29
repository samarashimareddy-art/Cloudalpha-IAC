################################################################################
# Component Output
################################################################################

output "component_attributes" {
  description = "Key attributes of the Image Builder components including metadata and tags."
  value = {
    for name, comp in try(aws_imagebuilder_component.this, {}) : name => {
      arn          = try(comp.arn, "")
      date_created = try(comp.date_created, "")
      encrypted    = try(comp.encrypted, false)
      owner        = try(comp.owner, "")
      tags_all     = try(comp.tags_all, {})
      type         = try(comp.type, "")
    }
  }
}


################################################################################
# Image Recipes Output
################################################################################


output "image_recipes" {
  description = "Details of all Image Builder image recipes including key metadata and tags."
  value = [
    for recipe in try(aws_imagebuilder_image_recipe.this, []) : {
      name         = try(recipe.name, "")
      arn          = try(recipe.arn, "")
      date_created = try(recipe.date_created, "")
      owner        = try(recipe.owner, "")
      platform     = try(recipe.platform, "")
      tags_all     = try(recipe.tags_all, {})
    }
  ]
}


################################################################################
# Cntainer Recipe Output
################################################################################

output "container_recipe_attributes" {
  description = "Key attributes of each Image Builder container recipe, including metadata and tags."
  value = {
    for name, recipe in try(aws_imagebuilder_container_recipe.this, {}) : name => {
      arn          = try(recipe.arn, "")
      date_created = try(recipe.date_created, "")
      encrypted    = try(recipe.encrypted, false)
      owner        = try(recipe.owner, "")
      platform     = try(recipe.platform, "")
      tags_all     = try(recipe.tags_all, {})
    }
  }
}



################################################################################
# Infrastructure Configuration Outputs 
################################################################################

output "infrastructure_configuration_attributes" {
  description = "List of key attributes for each infrastructure configuration, including creation and update details."
  value = [
    for ic in try(aws_imagebuilder_infrastructure_configuration.this, []) : {
      name         = try(ic.name, "")
      id           = try(ic.id, "")
      arn          = try(ic.arn, "")
      date_created = try(ic.date_created, "")
      date_updated = try(ic.date_updated, "")
      tags_all     = try(ic.tags_all, {})
    }
  ]
}


################################################################################
# Distribution Configuration Outputs 
################################################################################

output "distribution_configurations" {
  description = "List of distribution configurations with their key attributes."
  value = [
    for dc in try(aws_imagebuilder_distribution_configuration.this, []) : {
      name         = try(dc.name, "")
      arn          = try(dc.arn, "")
      date_created = try(dc.date_created, "")
      date_updated = try(dc.date_updated, "")
      tags_all     = try(dc.tags_all, {})
    }
  ]
}


################################################################################
# Workflow Outputs
################################################################################

output "imagebuilder_workflows" {
  description = "List of objects representing Image Builder workflows with ARN, creation date, and owner."
  value = [
    for w in try(aws_imagebuilder_workflow.this, []) : {
      arn          = try(w.arn, "")
      date_created = try(w.date_created, "")
      owner        = try(w.owner, "")
    }
  ]
}

################################################################################
# lifecycle_policy Output
################################################################################

output "lifecycle_policy_attributes" {
  description = "List of lifecycle policy attributes."
  value = [
    for lifecycle_policy in try(aws_imagebuilder_lifecycle_policy.this, []) : {
      id       = try(lifecycle_policy.id, "")
      arn      = try(lifecycle_policy.arn, "")
      status   = try(lifecycle_policy.status, "")
      tags_all = try(lifecycle_policy.tags_all, {})
    }
  ]
}


################################################################################
# Image Outputs
################################################################################

output "image_details" {
  description = "Details of the Image Builder image including metadata, OS info, and tags."
  value = {
    arn         = try(aws_imagebuilder_image.this[0].arn, "")
    date_created = try(aws_imagebuilder_image.this[0].date_created, "")
    platform     = try(aws_imagebuilder_image.this[0].platform, "")
    os_version   = try(aws_imagebuilder_image.this[0].os_version, "")
    version      = try(aws_imagebuilder_image.this[0].version, "")
    tags_all     = try(aws_imagebuilder_image.this[0].tags_all, {})
  }
}



################################################################################
# Image Builder Pipeline Outputs
################################################################################

output "image_pipeline_details" {
  description = "Details of the Image Builder pipeline including metadata and lifecycle attributes."
  value = {
    arn             = try(aws_imagebuilder_image_pipeline.this[0].arn, "")
    date_created    = try(aws_imagebuilder_image_pipeline.this[0].date_created, "")
    date_last_run   = try(aws_imagebuilder_image_pipeline.this[0].date_last_run, "")
    date_next_run   = try(aws_imagebuilder_image_pipeline.this[0].date_next_run, "")
    date_updated    = try(aws_imagebuilder_image_pipeline.this[0].date_updated, "")
    platform        = try(aws_imagebuilder_image_pipeline.this[0].platform, "")
    tags_all        = try(aws_imagebuilder_image_pipeline.this[0].tags_all, {})
  }
}
