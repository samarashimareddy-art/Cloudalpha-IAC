################################################################################
# Private Route Table - Variables
################################################################################

#variable "private_route_tables" {
#description = "Private route tables"
#type        = list(map(any))
#}

variable "private_route_tables" {
  description = "List of private route tables configuration"
  type = list(object({
    name = string
  }))
}

variable "private_route_table_propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
}

variable "private_route_table_routes" {
  description = "Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route"
  type = list(list(object({
    cidr_block                   = optional(string)
    ipv6_cidr_block              = optional(string)
    destination_prefix_list_id   = optional(string)
    core_network_arn             = optional(string)
    egress_only_gateway_id       = optional(string)
    gateway_id                   = optional(string)
    nat_gateway_id               = optional(string)
    transit_gateway_id           = optional(string)
    vpc_endpoint_id              = optional(string)
    vpc_peering_connection_id    = optional(string)
    internal_igw                 = optional(bool)
    internal_egress_only_igw     = optional(bool)
    internal_public_nat_gateway  = optional(bool)
    internal_private_nat_gateway = optional(bool)
  })))
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "private_subnets_length" {
  description = "Length of the private subnet list"
  type        = number
}

variable "public_subnets_length" {
  description = "The length of the public subnets list"
  type        = number
}

variable "create_vpc" {
  description = "Controls whether the VPC should be created"
  type        = bool
}

variable "create_egress_only_igw" {
  description = "Whether to create an Egress-only Internet Gateway"
  type        = bool
}

variable "enable_ipv6" {
  description = "Whether IPv6 is enabled for the VPC"
  type        = bool
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway for the VPC"
  type        = bool
}

variable "enable_public_nat_gateway" {
  description = "Whether to enable public NAT Gateway creation"
  type        = bool
}

variable "general_tags" {
  description = "General tags to apply to all resources (e.g., Owner, Environment)"
  type        = map(string)
}

variable "enable_private_nat_gateway" {
  description = "Whether to enable private NAT Gateway creation"
  type        = bool
}

variable "public_nat_gateway_ids" {
  description = "List of public NAT Gateway IDs"
  type        = list(string)
  default     = []
}

variable "private_nat_gateway_ids" {
  description = "List of private NAT Gateway IDs"
  type        = list(string)
  default     = []
}