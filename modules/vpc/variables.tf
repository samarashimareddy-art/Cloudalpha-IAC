################################################################################
# VPC Configuration
################################################################################

variable "create_vpc" {
  description = "Controls if VPC should be created"
  type        = bool
  default     = true
}

variable "existing_vpc_id" {
  description = "ID of existing VPC to use when create_vpc is false"
  type        = string
  default     = null
}

variable "vpc_config" {
  description = "VPC configuration"
  type = object({
    name                            = string
    ipv4_cidr                       = optional(string)
    use_ipv4_ipam_pool              = optional(bool, false)
    ipv4_ipam_pool_id               = optional(string)
    ipv4_netmask_length             = optional(number)
    enable_ipv6                     = optional(bool, false)
    use_ipv6_ipam_pool              = optional(bool, false)
    amazon_provided_ipv6_cidr_block = optional(bool, false)
    ipv6_cidr                       = optional(string)
    ipv6_ipam_pool_id               = optional(string)
    ipv6_netmask_length             = optional(number)
    instance_tenancy                = optional(string, "default")
    enable_dns_hostnames            = optional(bool, false)
    enable_dns_support              = optional(bool, true)
  })
  default = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC"
  type        = list(string)
  default     = []
}

################################################################################
# Subnet Configuration
################################################################################

variable "create_subnets" {
  description = "Controls if subnets should be created"
  type        = bool
  default     = true
}

variable "public_subnets" {
  description = "List of public subnet configurations"
  type = list(object({
    cidr_block                                     = string
    availability_zone                              = string
    ipv6_cidr_block                                = optional(string)
    assign_ipv6_address_on_creation                = optional(bool)
    enable_dns64                                   = optional(bool)
    map_public_ip_on_launch                        = optional(bool)
    enable_resource_name_dns_a_record_on_launch    = optional(bool)
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)
  }))
  default = []
}

variable "private_subnets" {
  description = "List of private subnet configurations"
  type = list(object({
    cidr_block                                     = string
    availability_zone                              = string
    ipv6_cidr_block                                = optional(string)
    assign_ipv6_address_on_creation                = optional(bool)
    enable_dns64                                   = optional(bool)
    map_public_ip_on_launch                        = optional(bool)
    enable_resource_name_dns_a_record_on_launch    = optional(bool)
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)
  }))
  default = []
}

################################################################################
# Internet Gateway Configuration
################################################################################

variable "create_internet_gateway" {
  description = "Controls if Internet Gateway should be created"
  type        = bool
  default     = true
}

variable "internet_gateway_tags" {
  description = "Additional tags for the Internet Gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# NAT Gateway Configuration
################################################################################

variable "create_nat_gateway" {
  description = "Controls if NAT Gateway should be created"
  type        = bool
  default     = false
}

variable "enable_public_nat_gateway" {
  description = "Should be true if you want to provision public NAT Gateways"
  type        = bool
  default     = false
}

variable "enable_private_nat_gateway" {
  description = "Should be true if you want to provision private NAT Gateways"
  type        = bool
  default     = false
}

variable "single_public_nat_gateway" {
  description = "Should be true to provision a single shared NAT Gateway across all private networks"
  type        = bool
  default     = false
}

variable "single_private_nat_gateway" {
  description = "Should be true to provision a single shared private NAT Gateway"
  type        = bool
  default     = false
}

variable "reuse_public_nat_eips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways"
  type        = bool
  default     = false
}

variable "external_public_nat_eips" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_public_nat_eips)"
  type        = list(string)
  default     = []
}

variable "assign_custom_privateIP_to_public_nat_gw" {
  description = "Should be true if you want to assign custom private IP to public NAT Gateway"
  type        = bool
  default     = false
}

variable "public_nat_gw_private_ip" {
  description = "List of private IPs to assign to public NAT Gateways"
  type        = list(string)
  default     = []
}

variable "assign_custom_privateIP_to_private_nat_gw" {
  description = "Should be true if you want to assign custom private IP to private NAT Gateway"
  type        = bool
  default     = false
}

variable "private_nat_gw_private_ip" {
  description = "List of private IPs to assign to private NAT Gateways"
  type        = list(string)
  default     = []
}

variable "public_nat_eip_tags" {
  description = "Additional tags for the public NAT EIPs"
  type        = map(string)
  default     = {}
}

variable "public_nat_gateway_tags" {
  description = "Additional tags for the public NAT gateways"
  type        = map(string)
  default     = {}
}

variable "private_nat_gateway_tags" {
  description = "Additional tags for the private NAT gateways"
  type        = list(map(string))
  default     = []
}

################################################################################
# Route Table Configuration
################################################################################

variable "create_public_route_table" {
  description = "Controls if public route table should be created"
  type        = bool
  default     = true
}

variable "create_private_route_table" {
  description = "Controls if private route tables should be created"
  type        = bool
  default     = true
}

variable "create_route_table_associations" {
  description = "Controls if route table associations should be created"
  type        = bool
  default     = true
}

variable "public_route_table_routes" {
  description = "Map of routes for public route table"
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
    internal_igw               = optional(bool, false)
    internal_egress_only_igw   = optional(bool, false)
  }))
  default = {}
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route table"
  type        = map(string)
  default     = {}
}

variable "private_route_tables" {
  description = "List of private route table configurations"
  type = list(object({
    name = string
  }))
  default = []
}

variable "private_route_table_routes" {
  description = "List of routes for each private route table"
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
    internal_igw                 = optional(bool, false)
    internal_egress_only_igw     = optional(bool, false)
    internal_public_nat_gateway  = optional(bool, false)
    internal_private_nat_gateway = optional(bool, false)
  })))
  default = []
}

variable "private_route_table_propagating_vgws" {
  description = "A list of VGWs the private route table should propagate"
  type        = list(string)
  default     = []
}

variable "external_public_route_table_id" {
  description = "ID of external public route table to use for associations"
  type        = string
  default     = null
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}

variable "external_private_route_table_ids" {
  description = "List of external private route table IDs to use for associations"
  type        = list(string)
  default     = []
}

################################################################################
# Security Group Configuration
################################################################################

variable "create_security_groups" {
  description = "Controls if security groups should be created"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "List of security group configurations"
  type = list(object({
    name        = string
    description = optional(string)
    ingress = optional(list(object({
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      prefix_list_ids  = optional(list(string))
      security_groups  = optional(list(string))
      self             = optional(bool)
      description      = optional(string)
    })), [])
    egress = optional(list(object({
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      prefix_list_ids  = optional(list(string))
      security_groups  = optional(list(string))
      self             = optional(bool)
      description      = optional(string)
    })), [])
  }))
  default = []
}

################################################################################
# Network ACL Configuration
################################################################################

variable "create_network_acl" {
  description = "Controls if Network ACLs should be created"
  type        = bool
  default     = false
}

variable "public_dedicated_network_acl" {
  description = "Whether to create a dedicated network ACL for public subnets"
  type        = bool
  default     = false
}

variable "private_dedicated_network_acl" {
  description = "Whether to create a dedicated network ACL for private subnets"
  type        = bool
  default     = false
}

variable "public_network_acl_ingress" {
  description = "List of ingress rules for the public network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = []
}

variable "public_network_acl_egress" {
  description = "List of egress rules for the public network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = []
}

variable "private_network_acl_ingress" {
  description = "List of ingress rules for the private network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = []
}

variable "private_network_acl_egress" {
  description = "List of egress rules for the private network ACL"
  type = list(object({
    rule_no         = number
    action          = string
    cidr_block      = optional(string)
    to_port         = number
    from_port       = number
    protocol        = string
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = []
}

variable "public_acl_tags" {
  description = "Tags to apply to public network ACLs"
  type        = map(string)
  default     = {}
}

variable "private_acl_tags" {
  description = "Tags to apply to private network ACLs"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC Flow Logs Configuration
################################################################################

variable "enable_flow_logs" {
  description = "Controls if VPC Flow Logs should be enabled"
  type        = bool
  default     = false
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "flow_log_subnet_id" {
  description = "The ID of the subnet to associate with the flow log"
  type        = string
  default     = ""
}

variable "flow_log_eni_id" {
  description = "The ID of the Elastic Network Interface to associate with the flow log"
  type        = string
  default     = ""
}

variable "flow_log_transit_gateway_id" {
  description = "The ID of the Transit Gateway to associate with the flow log"
  type        = string
  default     = ""
}

variable "flow_log_transit_gateway_attachment_id" {
  description = "The ID of the Transit Gateway Attachment to associate with the flow log"
  type        = string
  default     = ""
}

variable "flow_log_iam_role_arn" {
  description = "The ARN of the IAM role for CloudWatch or Firehose"
  type        = string
  default     = ""
}

variable "flow_log_deliver_cross_account_role" {
  description = "ARN of the IAM role for cross-account log delivery"
  type        = string
  default     = ""
}

variable "flow_log_destination_arn" {
  description = "The ARN of the logging destination (CloudWatch Log Group, S3 bucket, or Firehose)"
  type        = string
  default     = ""
}

variable "flow_log_destination_type" {
  description = "The type of the logging destination: cloud-watch-logs, s3, kinesis-data-firehose"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_format" {
  description = "Fields to include in the flow log record"
  type        = string
  default     = ""
}

variable "flow_log_max_aggregation_interval" {
  description = "Maximum interval for aggregation: 60 or 600"
  type        = number
  default     = 600
}

variable "flow_log_destination_options" {
  description = "Options for the flow log destination"
  type = object({
    file_format                = optional(string, "plain-text")
    hive_compatible_partitions = optional(bool, false)
    per_hour_partition         = optional(bool, false)
  })
  default = null
}

variable "flow_log_role_name" {
  description = "Name of the IAM role for VPC Flow Logs"
  type        = string
  default     = ""
}

variable "flow_log_policy_name" {
  description = "Name of the inline policy for VPC Flow Logs"
  type        = string
  default     = ""
}

variable "flow_log_create_iam_role" {
  description = "Whether to create an IAM role for flow logs"
  type        = bool
  default     = true
}

variable "flow_log_create_log_group" {
  description = "Whether to create a CloudWatch Log Group for flow logs"
  type        = bool
  default     = true
}

variable "flow_log_log_group_name" {
  description = "Name of the CloudWatch Log Group for flow logs"
  type        = string
  default     = "/aws/vpc/flowlogs"
}

variable "flow_log_log_group_retention_days" {
  description = "Retention period for CloudWatch Log Group in days"
  type        = number
  default     = 14
}

################################################################################
# Default VPC Configuration
################################################################################

variable "manage_default_vpc" {
  description = "Flag to manage the default VPC"
  type        = bool
  default     = false
}

variable "default_vpc_enable_dns_support" {
  description = "Enable DNS support on the default VPC"
  type        = bool
  default     = true
}

variable "default_vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames on the default VPC"
  type        = bool
  default     = false
}

variable "default_vpc_tags" {
  description = "Tags to apply specifically to the default VPC"
  type        = map(string)
  default     = {}
}

################################################################################
# General Configuration
################################################################################

variable "general_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}