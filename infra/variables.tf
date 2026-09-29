variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
  default     = "dev"
}

variable "suffix" {
  description = "Unique suffix so the bucket name is globally unique"
  type        = string
  default     = "739572512568"
}
