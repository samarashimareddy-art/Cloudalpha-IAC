################################################################################
# Virtual Private Gateway Route Table - Variables
################################################################################

variable "create_vpc" {
  description = "Controls whether VPC resources should be created"
  type        = bool
}

variable "enable_vpn_gateway" {
  description = "Whether to enable VPN Gateway resources"
  type        = bool
}

variable "virtual_private_gw_route_table_routes" {
  description = "Routes to be added to the Virtual Private Gateway route table"
  type = list(object({
    cidr_block                 = optional(string)
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)
    network_interface_id       = optional(string)
  }))
}

variable "virtual_private_gw_route_table_tags" {
  description = "Tags specific to the Virtual Private Gateway route table"
  type        = map(string)
}

variable "general_tags" {
  description = "General tags to apply to all resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the VPN gateway route table"
  type        = string
}
