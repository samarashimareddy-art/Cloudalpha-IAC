variable "egress_rules" {
  description = "Map of egress rules to create for security groups"
  type = map(object({
    security_group_id            = string
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = string
    to_port                      = optional(number)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string))
  }))
  default = {}
}

variable "ingress_rules" {
  description = "Map of ingress rules to create for security groups"
  type = map(object({
    security_group_id            = string
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = string
    to_port                      = optional(number)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string))
  }))
  default = {}
}

variable "sg_vpc_associations" {
  description = "Map of security group VPC associations to create"
  type = map(object({
    security_group_id = string
    vpc_id            = string
  }))
  default = {}
}

variable "default_tags" {
  description = "Default tags to apply to all rules"
  type        = map(string)
  default     = {}
}
