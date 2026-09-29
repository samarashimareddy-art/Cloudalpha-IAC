################################################################################
# Public Route Table - Variables
################################################################################

variable "create_vpc" {
  description = "Controls whether the VPC should be created"
  type        = bool
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
}

variable "create_egress_only_igw" {
  description = "Whether to create an egress-only Internet Gateway"
  type        = bool
}

variable "enable_ipv6" {
  description = "Whether IPv6 is enabled"
  type        = bool
}

variable "public_route_table_routes" {
  description = <<-EOT
    A map of route definitions for the public route table.
    Example:
    {
      "route1" = {
        cidr_block                = "0.0.0.0/0"
        internal_igw              = true
        gateway_id                = null
        egress_only_gateway_id    = null
        network_interface_id      = null
        vpc_endpoint_id           = null
        vpc_peering_connection_id = null
        transit_gateway_id        = null
        core_network_arn          = null
        internal_egress_only_igw  = false
      }
    }
  EOT
  type = map(object({
    cidr_block                 = optional(string)
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)
    core_network_arn           = optional(string)
    egress_only_gateway_id     = optional(string)
    gateway_id                 = optional(string)
    network_interface_id       = optional(string)
    transit_gateway_id         = optional(string)
    vpc_endpoint_id            = optional(string)
    vpc_peering_connection_id  = optional(string)
    internal_igw               = optional(bool)
    internal_egress_only_igw   = optional(bool)
  }))
}

variable "public_route_table_tags" {
  description = "Tags specific to the public route table"
  type        = map(string)
}

variable "general_tags" {
  description = "General tags to apply to all resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}
