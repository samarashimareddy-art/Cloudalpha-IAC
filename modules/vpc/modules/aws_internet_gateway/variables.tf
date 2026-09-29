variable "create_vpc" {
  description = "Whether to create the VPC or not"
  type        = bool
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
}

variable "public_subnets" {
  description = "List of public subnet IDs (used to determine if IGW is needed)"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID to attach the internet gateway to"
  type        = string
}

variable "igw_tags" {
  description = "Tags specific to the Internet Gateway"
  type        = map(string)
}

variable "general_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
