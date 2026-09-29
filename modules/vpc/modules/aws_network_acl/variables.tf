variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
}

variable "create_vpc" {
  description = "Flag to determine whether to create resources in the VPC"
  type        = bool
}

variable "public_dedicated_network_acl" {
  description = "Whether to create a dedicated network ACL for public subnets"
  type        = bool
}

variable "private_dedicated_network_acl" {
  description = "Whether to create a dedicated network ACL for private subnets"
  type        = bool
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_network_acl_ingress" {
  description = "List of ingress rules for the public network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
}

variable "public_network_acl_egress" {
  description = "List of egress rules for the public network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
}

variable "private_network_acl_ingress" {
  description = "List of ingress rules for the private network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
}

variable "private_network_acl_egress" {
  description = "List of egress rules for the private network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
}

variable "public_acl_tags" {
  description = "Tags to apply to public network ACLs"
  type        = map(string)
}

variable "private_acl_tags" {
  description = "Tags to apply to private network ACLs"
  type        = map(string)
}

variable "general_tags" {
  description = "General tags to apply to all resources"
  type        = map(string)
}
