variable "rules" {
  description = "Map of security group rules."
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    security_group_id        = string
    cidr_blocks              = optional(list(string))
    ipv6_cidr_blocks         = optional(list(string))
    prefix_list_ids          = optional(list(string))
    self                     = optional(bool)
    source_security_group_id = optional(string)
    description              = optional(string)
  }))
}
