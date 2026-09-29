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

variable "vpc_cidr" {
  description = "CIDR block for the demo VPC"
  type        = string
  default     = "10.50.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the single public subnet"
  type        = string
  default     = "10.50.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type (free-tier friendly)"
  type        = string
  default     = "t3.micro"
}
