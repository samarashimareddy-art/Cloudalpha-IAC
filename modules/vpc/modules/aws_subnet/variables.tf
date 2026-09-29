variable "vpc_id" {
  type        = string
  description = "ID of the VPC where subnets will be created"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to each subnet"
}

variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string

    # Optional fields
    ipv6_cidr_block                                = optional(string)
    assign_ipv6_address_on_creation                = optional(bool)
    enable_dns64                                   = optional(bool)
    map_public_ip_on_launch                        = optional(bool)
    enable_resource_name_dns_a_record_on_launch    = optional(bool)
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)
  }))
  description = "List of public subnet configurations"
}

variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string

    # Optional fields
    ipv6_cidr_block                                = optional(string)
    assign_ipv6_address_on_creation                = optional(bool)
    enable_dns64                                   = optional(bool)
    map_public_ip_on_launch                        = optional(bool)
    enable_resource_name_dns_a_record_on_launch    = optional(bool)
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)
  }))
  description = "List of private subnet configurations"
}
