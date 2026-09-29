variable "endpoint_services" {
  description = "Map of endpoint service configurations"
  type = map(object({
    acceptance_required        = bool
    network_load_balancer_arns = list(string)
    gateway_load_balancer_arns = optional(list(string))
    private_dns_name           = optional(string)
    supported_ip_address_types = optional(list(string))
    supported_regions          = optional(list(string))
  }))
}

variable "allowed_principals" {
  description = "Map of allowed principal configurations"
  type = map(object({
    vpc_endpoint_service_id = string
    principal_arn           = string
  }))
}

variable "service_tags" {
  description = "Tags to apply to endpoint service resources"
  type        = map(string)
}
