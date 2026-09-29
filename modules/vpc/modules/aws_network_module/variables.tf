variable "vpc_id" {
  description = "The ID of the VPC for the network ACL"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the network ACL"
  type        = list(string)
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
}

# Network ACL Rule
variable "network_acl_id" {
  description = "ID of the network ACL"
  type        = string
}

variable "subnet_association_subnet_id" {
  description = "Subnet ID to associate with the ACL"
  type        = string
}

variable "rule_number" {
  description = "Rule number for ACL rule"
  type        = number
}

variable "egress" {
  description = "True if rule is egress, false for ingress"
  type        = bool
}

variable "rule_protocol" {
  description = "Protocol to match"
  type        = string
}

variable "rule_action" {
  description = "Action to take (allow or deny)"
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block to match"
  type        = string
}

variable "from_port" {
  description = "Start of port range"
  type        = number
}

variable "to_port" {
  description = "End of port range"
  type        = number
}

variable "ipv6_cidr_block" {
  description = "IPv6 CIDR block to match"
  type        = string
  nullable    = true
}

variable "icmp_code" {
  description = "ICMP code"
  type        = number
  nullable    = true
}

variable "icmp_type" {
  description = "ICMP type"
  type        = number
  nullable    = true
}

# Network Interface
variable "subnet_id" {
  description = "Subnet ID to create the ENI in"
  type        = string
}

variable "description" {
  description = "Description for the network interface"
  type        = string
  nullable    = true
}

variable "enable_primary_ipv6" {
  description = "Enable primary IPv6 on the ENI"
  type        = bool
  nullable    = true
}

variable "interface_type" {
  description = "Type of interface (efa, interface, etc.)"
  type        = string
  nullable    = true
}

variable "ipv4_prefix_count" {
  description = "Count of IPv4 prefixes to assign"
  type        = number
  nullable    = true
}

variable "ipv4_prefixes" {
  description = "List of IPv4 prefixes to assign"
  type        = list(string)
  nullable    = true
}

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses"
  type        = number
  nullable    = true
}

variable "ipv6_address_list_enabled" {
  description = "Enable ipv6_address_list"
  type        = bool
  nullable    = true
}

variable "ipv6_address_list" {
  description = "List of ordered IPv6 addresses"
  type        = list(string)
  nullable    = true
}

variable "ipv6_addresses" {
  description = "List of IPv6 addresses to assign"
  type        = list(string)
  nullable    = true
}

variable "ipv6_prefix_count" {
  description = "Number of IPv6 prefixes"
  type        = number
  nullable    = true
}

variable "ipv6_prefixes" {
  description = "List of IPv6 prefixes"
  type        = list(string)
  nullable    = true
}

variable "private_ip_list_enabled" {
  description = "Enable private_ip_list"
  type        = bool
  nullable    = true
}

variable "private_ip_list" {
  description = "Ordered list of private IPs"
  type        = list(string)
  nullable    = true
}

variable "private_ips" {
  description = "Unordered list of private IPs"
  type        = list(string)
  nullable    = true
}

variable "private_ips_count" {
  description = "Number of secondary private IPs"
  type        = number
  nullable    = true
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
  nullable    = true
}

variable "source_dest_check" {
  description = "Enable source/destination check"
  type        = bool
  nullable    = true
}

variable "attach_network_interface" {
  description = "Boolean to conditionally attach the ENI"
  type        = bool
}

variable "instance_id" {
  description = "Instance ID for ENI attachment"
  type        = string
}

variable "device_index" {
  description = "Device index for attachment"
  type        = number
}

# ENI Permissions
variable "account_id" {
  description = "AWS account ID to grant permission"
  type        = string
}

variable "permission" {
  description = "Permission type (INSTANCE-ATTACH)"
  type        = string
}

# Additional SG Attachment
variable "additional_sg_id" {
  description = "Additional security group to attach"
  type        = string
}
