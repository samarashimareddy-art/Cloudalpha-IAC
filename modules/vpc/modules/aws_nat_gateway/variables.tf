variable "create_vpc" {
  description = "Whether to create the VPC and related resources"
  type        = bool
}

variable "enable_public_nat_gateway" {
  description = "Flag to enable creation of public NAT Gateway(s)"
  type        = bool
}

variable "enable_private_nat_gateway" {
  description = "Flag to enable creation of private NAT Gateway(s)"
  type        = bool
}

variable "single_public_nat_gateway" {
  description = "Whether to create a single public NAT Gateway"
  type        = bool
}

variable "single_private_nat_gateway" {
  description = "Whether to create a single private NAT Gateway"
  type        = bool
}

variable "reuse_public_nat_eips" {
  description = "Whether to reuse existing Elastic IPs for public NAT Gateways"
  type        = bool
}

variable "external_public_nat_eips" {
  description = "List of existing EIP IDs to use for public NAT Gateways if reusing"
  type        = list(string)
  default     = []
}

variable "assign_custom_privateIP_to_public_nat_gw" {
  description = "Whether to assign custom private IPs to public NAT Gateways"
  type        = bool
}

variable "assign_custom_privateIP_to_private_nat_gw" {
  description = "Whether to assign custom private IPs to private NAT Gateways"
  type        = bool
}

variable "public_nat_gw_private_ip" {
  description = "List of custom private IPs for public NAT Gateways"
  type        = list(string)
  default     = []
}

variable "private_nat_gw_private_ip" {
  description = "List of custom private IPs for private NAT Gateways"
  type        = list(string)
  default     = []
}

variable "public_nat_eip_tags" {
  description = "Tags to apply to public NAT EIP(s)"
  type        = map(string)
}

variable "public_nat_gateway_tags" {
  description = "Tags to apply to public NAT Gateway(s)"
  type        = map(string)
}

variable "private_nat_gateway_tags" {
  description = "List of maps of tags to apply to each private NAT Gateway"
  type        = list(map(string))
}

variable "general_tags" {
  description = "Common/general tags to apply to all resources"
  type        = map(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}
