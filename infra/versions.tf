terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Remote state, so every pipeline run sees what earlier runs created.
  # The bucket is created once by hand (see README); use_lockfile gives
  # S3-native state locking (Terraform >= 1.10), no DynamoDB table needed.
  backend "s3" {
    bucket       = "cloudalpha-demo-tfstate-739572512568"
    key          = "cloudalpha-iac/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
