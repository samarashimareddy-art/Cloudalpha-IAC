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

variable "app_port" {
  description = "Port the Cloudalpha-App container listens on"
  type        = number
  default     = 3000
}

variable "ecs_execution_role_arn" {
  description = "ECS task execution role (pulls the image from ECR, writes logs); created once outside Terraform"
  type        = string
  default     = "arn:aws:iam::739572512568:role/cloudalpha-demo-ecs-execution-role"
}

variable "allowed_cidrs" {
  description = "Source ranges allowed to reach the app (Zscaler egress ranges)"
  type        = list(string)
  default = [
    "101.2.248.0/23", "136.226.224.0/19", "165.225.104.0/22", "165.225.120.0/21", "167.103.0.0/16",
    "175.107.136.0/21", "205.220.16.0/20", "136.226.160.0/19", "136.226.192.0/19", "147.161.128.0/18",
    "194.9.96.0/19", "165.225.16.0/22", "167.103.218.0/23", "170.85.0.0/16", "136.226.0.0/16",
    "104.129.192.0/20", "159.254.0.0/18", "165.225.192.0/18", "205.220.0.0/18", "198.14.64.0/19",
  ]
}

variable "instance_type" {
  description = "EC2 instance type (free-tier friendly)"
  type        = string
  default     = "t3.micro"
}
