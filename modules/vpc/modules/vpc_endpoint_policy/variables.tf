variable "endpoint_policies" {
  description = "Map of endpoint policy configurations"
  type = map(object({
    vpc_endpoint_id = string
    policy          = string
  }))
}
