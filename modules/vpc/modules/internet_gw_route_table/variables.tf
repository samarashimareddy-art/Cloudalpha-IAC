################################################################################
# Internet Gateway Route Table - Variables
################################################################################

variable "create_vpc" {
  description = "Controls whether VPC should be created"
  type        = bool
}

variable "create_igw" {
  description = "Controls whether Internet Gateway should be created"
  type        = bool
}

variable "internet_gw_route_table_routes" {
  description = <<-EOT
    A map of route definitions for the Internet Gateway route table.
    Example:
    {
      "route1" = {
        cidr_block           = "0.0.0.0/0"
        vpc_endpoint_id      = "vpce-xxxxxxxx"
        network_interface_id = null
      }
    }
  EOT
  type = map(object({
    cidr_block                 = optional(string)
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)
    network_interface_id       = optional(string)
    vpc_endpoint_id            = optional(string)
  }))
}

variable "internet_gw_route_table_tags" {
  description = "Tags to apply specifically to the IGW route table"
  type        = map(string)
}

variable "general_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "ID of the VPC to associate the route table with"
  type        = string
}
