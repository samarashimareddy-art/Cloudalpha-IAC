variable "create_vpc" {
  description = "Flag to control whether the VPC and related resources should be created"
  type        = bool
}

variable "create_igw" {
  description = "Flag to control whether to create an Internet Gateway"
  type        = bool
}

variable "enable_vpn_gateway" {
  description = "Flag to control whether to create and associate a VPN Gateway"
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

variable "private_route_tables" {
  description = "List of private route table IDs to associate with private subnets"
  type        = list(string)
}

variable "public_route_table_id" {
  description = "ID of the public route table to associate with public subnets"
  type        = string
  default     = ""
}
