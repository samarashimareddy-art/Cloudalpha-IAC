# EC2 Image Builder Terraform Module

This Terraform module provides support for managing AWS EC2 Image Builder resources, including components, image recipes, container recipes, infrastructure configurations, distribution configurations, workflows, lifecycle policies, and image pipelines.

## Requirements

| Name      | Version   |
|-----------|-----------|
| terraform | >= 1.5.0  |
| aws       | >= 5.9.0  |


## Conditions

- `create_*` flags must be set to `true` to enable creation of their respective resources.
- If a resource flag is `true`, the corresponding configuration variable (e.g., `components`, `image_recipes`) must be populated with valid values.
- `pipeline_config` is required when `create_image_pipeline` is `true`, and must include valid ARNs or object references for dependent resources.
- For `workflows_lifecycle_policies`, `enable_lifecycle_policy_creation` must be set to `true` to apply any configurations.

## Notes

- Nested configurations for complex resources such as `image_recipes` or `infrastructure_configurations` must follow the structure and schema expected by AWS Image Builder.
- IAM roles required for Image Builder resources (like `infrastructure_configuration`) must be created outside this module or passed via variables, unless extended internally.
- The module avoids using unsupported or deprecated attributes and aligns strictly with the Terraform AWS Provider documentation.

## Features

- Supports both EC2 image and container image pipelines.
- Provides fine-grained control over lifecycle policies, workflows, and distribution settings.
- Enables conditional creation of each component for maximum flexibility.
- Uses flat input structure for simplicity and Terragrunt compatibility.
- Optimized for modular reuse and can integrate with shared IAM, networking, and ECR modules.

## Directory Structure

```hcl
submodule/
└── ec2-image-builder/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    └── example/
        └── terragrunt.hcl
```

## Usage

```hcl
module "image_builder" {
  source = "../"

  create_image_pipeline = true

  pipeline_config = {
    pipeline_name                      = "example-image-pipeline"
    infrastructure_configuration_arn   = "arn:aws:imagebuilder:us-east-1:123456789012:infrastructure-configuration/example"
    schedule_expression                = "cron(0 2 * * ? *)"
    pipeline_description               = "Example pipeline description"
    distribution_configuration_arn     = "arn:aws:imagebuilder:us-east-1:123456789012:distribution-configuration/example"
    enhanced_image_metadata_enabled    = true
    execution_role_arn                 = "arn:aws:iam::123456789012:role/AWSServiceRoleForImageBuilder"
    pipeline_status                    = "ENABLED"
    tags                               = {
      Environment = "dev"
      Project     = "image-pipeline"
    }
    image_recipe_arn                   = null
    container_recipe_arn               = "arn:aws:imagebuilder:us-east-1:123456789012:container-recipe/example/1.0.0"
    image_tests_enabled                = true
    image_tests_timeout_minutes        = 90
    image_scanning_enabled             = true
    ecr_repository_name                = "ec2-image-builder"
    ecr_container_tags                 = ["latest", "stable"]
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
    schedule_timezone                  = "UTC"

    pipeline_workflows = [
      {
        workflow_arn   = "arn:aws:imagebuilder:us-east-1:123456789012:workflow/test/example/1.0.0"
        type           = "test"
        on_failure     = "CONTINUE"
        parallel_group = "default"
        parameters = [
          {
            name  = "waitForActionAtEnd"
            value = "true"
          }
        ]
      },
      {
        workflow_arn   = "arn:aws:imagebuilder:us-east-1:123456789012:workflow/build/example/1.0.0"
        type           = "build"
        parameters = []
      }
    ]
  }
}
```

## Inputs

| Name                                     | Type    | Description                                                                                       | Default |
|------------------------------------------|---------|---------------------------------------------------------------------------------------------------|---------|
| create_components                        | bool    | Flag to create image builder components                                                           | false   |
| components                               | list    | List of component definitions                                                                     | null    |
| create_image_recipe                      | bool    | Flag to create image recipes                                                                      | false   |
| image_recipes                            | list    | List of image recipe configurations                                                               | null    |
| create_container_recipes                 | bool    | Flag to create container recipes                                                                  | false   |
| container_recipes                        | list    | List of container recipe configurations                                                           | null    |
| create_infrastructure_configurations     | bool    | Flag to create infrastructure configurations                                                      | false   |
| infrastructure_configurations            | list    | List of infrastructure configuration definitions                                                  | null    |
| create_distribution_configurations       | bool    | Flag to create distribution configurations                                                        | false   |
| distribution_configurations              | list    | List of distribution configuration definitions                                                    | null    |
| create_workflows                         | bool    | Flag to create workflows                                                                          | false   |
| workflows                                | list    | List of workflow configurations                                                                   | null    |
| enable_lifecycle_policy_creation         | bool    | Flag to enable lifecycle policy creation                                                          | false   |
| workflows_lifecycle_policies             | list    | List of lifecycle policy configurations                                                           | null    |
| enable_imagebuilder_image_creation       | bool    | Flag to enable creation of imagebuilder image                                                     | false   |
| imagebuilder_images                      | list    | List of imagebuilder image configurations                                                         | null    |
| create_image_pipeline                    | bool    | Flag to create image pipeline                                                                     | true    |
| pipeline_config                          | object  | Image pipeline configuration                                                                      | Must be set when `create_image_pipeline` is true |

> Note: Some nested attributes within lists may have their own required values depending on use case.


## Outputs

| Name                                  | Description                                                                                   |
|---------------------------------------|-----------------------------------------------------------------------------------------------|
| `component_attributes`                | Key attributes of the Image Builder components including metadata and tags.                   |
| `image_recipes`                       | Details of all Image Builder image recipes including key metadata and tags.                   |
| `container_recipe_attributes`         | Key attributes of each Image Builder container recipe, including metadata and tags.           |
| `infrastructure_configuration_attributes` | List of key attributes for each infrastructure configuration, including creation and update details. |
| `distribution_configurations`         | List of distribution configurations with their key attributes.                                |
| `imagebuilder_workflows`              | List of objects representing Image Builder workflows with ARN, creation date, and owner.      |
| `lifecycle_policy_attributes`         | List of lifecycle policy attributes.                                                          |
| `image_details`                       | Details of the Image Builder image including metadata, OS info, and tags.                     |
| `image_pipeline_details`              | Details of the Image Builder pipeline including metadata and lifecycle attributes.            |
