################################################################################
# VPC
################################################################################

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "vpc" {
  description = "AWS VPC"
  type = object({
    name                            = string
    ipv4_cidr                       = optional(string)
    use_ipv4_ipam_pool              = optional(bool)
    ipv4_ipam_pool_id               = optional(string)
    ipv4_netmask_length             = optional(number)
    enable_ipv6                     = optional(bool)
    use_ipv6_ipam_pool              = optional(bool)
    amazon_provided_ipv6_cidr_block = optional(bool)
    ipv6_cidr                       = optional(string)
    ipv6_ipam_pool_id               = optional(string)
    ipv6_netmask_length             = optional(number)
    instance_tenancy                = optional(string)
    enable_dns_hostnames            = optional(bool)
    enable_dns_support              = optional(bool)
  })
  default = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

########################### Associate secondary cidr blocks to vpc ############
variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  type        = list(string)
  default     = []
}

################################################################################
# General tags
################################################################################

variable "general_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}