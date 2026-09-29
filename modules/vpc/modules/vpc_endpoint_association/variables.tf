variable "route_table_associations" {
  description = "Map of route table associations"
  type = map(object({
    vpc_endpoint_id = string
    route_table_id  = string
  }))
}

variable "sg_associations" {
  description = "Map of security group associations"
  type = map(object({
    vpc_endpoint_id             = string
    security_group_id           = string
    replace_default_association = optional(bool)
  }))
}

variable "subnet_associations" {
  description = "Map of subnet associations"
  type = map(object({
    vpc_endpoint_id = string
    subnet_id       = string
  }))
}
