# AWS Default Subnet Terraform Module

## Overview

This Terraform module provisions an **AWS Default Subnet** in a specified **Availability Zone**. Default subnets are automatically configured to assign a public IP to instances upon launch. This module allows for customization of AWS-provided default subnets.

> **Note:** You can only have one default subnet per Availability Zone per VPC.

## Features

- Creates or manages an AWS Default Subnet
- Supports force deletion with `force_destroy`
- Tags resources for better organization
- Compatible with Terragrunt for environment-based deployments

## Usage

```hcl
module "default_subnet" {
  source = "../../modules/aws_default_subnet"

  availability_zone = "us-east-1a"
  force_destroy     = true

  tags = {
    Name        = "default-subnet-a"
    Environment = "dev"
  }
}

INPUTS
Name | Type | Description | Default | Required
availability_zone | string | The Availability Zone in which to create the subnet | n/a |
force_destroy | bool | Whether to forcefully delete the subnet and contents | false |
tags | map | Key-value map of tags to assign to the subnet | {} |

Outputs
Name | Description
subnet_id | The ID of the default subnet
arn | The ARN of the default subnet
cidr_block | The CIDR block of the default subnet

Example with Terragrunt
hcl
Copy
Edit
terraform {
  source = "../../../modules/aws_default_subnet"
}

inputs = {
  availability_zone = "us-east-1a"
  force_destroy     = true
  tags = {
    Name        = "default-subnet-a"
    Environment = "dev"
  }
}
Requirements
Terraform: v1.0 or later

AWS Provider: v5.0 or later

IAM permissions to manage VPC and subnets

License
This module is licensed under the MIT License.