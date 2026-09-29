################################################################################
# DHCP Options Set - Variables
################################################################################

variable "create_vpc" {
  description = "Controls whether VPC resources should be created"
  type        = bool
}

variable "enable_dhcp_options" {
  description = "Whether to create DHCP Options Set and associate it with the VPC"
  type        = bool
}

variable "dhcp_options_domain_name" {
  description = "Domain name for DHCP options"
  type        = string
}

variable "dhcp_options_domain_name_servers" {
  description = "List of domain name servers"
  type        = list(string)
}

variable "dhcp_options_ntp_servers" {
  description = "List of NTP servers"
  type        = list(string)
}

variable "dhcp_options_netbios_name_servers" {
  description = "List of NetBIOS name servers"
  type        = list(string)
}

variable "dhcp_options_netbios_node_type" {
  description = "NetBIOS node type"
  type        = string
}

variable "dhcp_options_tags" {
  description = "Tags specific to DHCP Options"
  type        = map(string)
}

variable "general_tags" {
  description = "General tags to apply to all resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the DHCP options set"
  type        = string
}