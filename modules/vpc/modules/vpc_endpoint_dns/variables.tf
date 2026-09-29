variable "private_dns_settings" {
  description = "Map of VPC endpoint private DNS settings"
  type = map(object({
    vpc_endpoint_id     = string
    private_dns_enabled = bool
  }))
}

variable "dns_verifications" {
  description = "Map of VPC endpoint service private DNS verifications"
  type = map(object({
    service_id            = string
    wait_for_verification = optional(bool)
  }))
}
