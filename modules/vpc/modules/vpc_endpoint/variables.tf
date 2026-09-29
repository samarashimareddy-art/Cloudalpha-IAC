variable "create_endpoint" {
  description = "Flag to enable or disable endpoint creation"
  type        = bool
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "endpoints" {
  description = "Map of VPC endpoint configurations"
  type = map(object({
    service_name        = string
    vpc_endpoint_type   = string
    auto_accept         = optional(bool)
    security_group_ids  = optional(list(string))
    subnet_ids          = optional(list(string))
    route_table_ids     = optional(list(string))
    policy              = optional(string)
    private_dns_enabled = optional(bool)
    ip_address_type     = optional(string)
    dns_record_ip_type  = optional(string)
  }))
}

variable "endpoint_tags" {
  description = "Tags specific to VPC endpoint resources"
  type        = map(string)
}

variable "general_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "endpoint_timeouts" {
  description = "Timeout values for create, update, delete"
  type        = map(string)
}

variable "endpoint_services" {
  description = "Map of configurations for VPC endpoint services"
  type = map(object({
    acceptance_required        = optional(bool)
    network_load_balancer_arns = list(string)
    gateway_load_balancer_arns = optional(list(string))
    allowed_principals         = optional(list(string))
    private_dns_name           = optional(string)
    supported_ip_address_types = optional(list(string))
  }))
}

variable "service_tags" {
  description = "Tags to apply to each VPC endpoint service"
  type        = map(string)
}
