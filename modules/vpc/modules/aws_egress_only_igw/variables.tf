variable "create_vpc" {
  description = "Whether to create the VPC or not"
  type        = bool
}

variable "create_egress_only_igw" {
  description = "Whether to create an egress-only internet gateway"
  type        = bool
}

variable "enable_ipv6" {
  description = "Whether IPv6 is enabled for the VPC"
  type        = bool
}

variable "vpc_id" {
  description = "VPC ID to attach the egress-only internet gateway to"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs (used to determine if egress-only IGW is needed)"
  type        = list(string)
}

variable "egress_only_igw_tags" {
  description = "Tags specific to the egress-only internet gateway"
  type        = map(string)
}

variable "general_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
