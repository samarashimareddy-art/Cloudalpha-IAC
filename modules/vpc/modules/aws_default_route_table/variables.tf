variable "create_vpc" {
  description = "Flag to control the creation of the VPC"
  type        = bool
}

variable "manage_default_route_table" {
  description = "Whether to manage the default route table"
  type        = bool
}

variable "default_route_table_propagating_vgws" {
  description = "A list of virtual gateways for route propagation"
  type        = list(string)
}

variable "default_route_table_routes" {
  description = "List of route objects for the default route table"
  type = list(object({
    cidr_block                   = optional(string)
    ipv6_cidr_block              = optional(string)
    destination_prefix_list_id   = optional(string)
    core_network_arn             = optional(string)
    egress_only_gateway_id       = optional(string)
    internal_egress_only_igw     = optional(bool)
    gateway_id                   = optional(string)
    internal_igw                 = optional(bool)
    nat_gateway_id               = optional(string)
    internal_public_nat_gateway  = optional(bool)
    internal_private_nat_gateway = optional(bool)
    network_interface_id         = optional(string)
    transit_gateway_id           = optional(string)
    vpc_endpoint_id              = optional(string)
    vpc_peering_connection_id    = optional(string)
  }))
}

variable "default_route_table_tags" {
  description = "Tags specific to the default route table"
  type        = map(string)
}

variable "general_tags" {
  description = "General tags to apply to all resources"
  type        = map(string)
}

variable "create_egress_only_igw" {
  description = "Flag to create an egress-only internet gateway"
  type        = bool
}

variable "enable_ipv6" {
  description = "Whether to enable IPv6"
  type        = bool
}

variable "create_igw" {
  description = "Flag to create an Internet Gateway"
  type        = bool
}

variable "enable_public_nat_gateway" {
  description = "Enable public NAT Gateway creation"
  type        = bool
}

variable "enable_private_nat_gateway" {
  description = "Enable private NAT Gateway creation"
  type        = bool
}

# You may also want to pass local.public_subnets_length if it's not local:
variable "public_subnets_length" {
  description = "Number of public subnets"
  type        = number
}

variable "default_route_table_id" {
  description = "The ID of the default route table for the VPC"
  type        = string
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway (from the internet_gateway module), used for routes with internal_igw = true"
  type        = string
  default     = null
}

variable "egress_only_gateway_id" {
  description = "ID of the egress-only Internet Gateway, used for routes with internal_egress_only_igw = true"
  type        = string
  default     = null
}

variable "public_nat_gateway_id" {
  description = "ID of the public NAT Gateway (from the nat_gateway module), used for routes with internal_public_nat_gateway = true"
  type        = string
  default     = null
}

variable "private_nat_gateway_id" {
  description = "ID of the private NAT Gateway (from the nat_gateway module), used for routes with internal_private_nat_gateway = true"
  type        = string
  default     = null
}