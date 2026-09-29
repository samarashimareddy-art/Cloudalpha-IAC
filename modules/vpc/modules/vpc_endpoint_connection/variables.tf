variable "accept_connections" {
  description = "Whether to accept VPC endpoint connection requests"
  type        = bool
}

variable "endpoint_accept_map" {
  description = "Map of endpoint connection accepter configuration"
  type = map(object({
    vpc_endpoint_id         = string
    vpc_endpoint_service_id = string
    auto_accept             = optional(bool)
  }))
}

variable "connection_notifications" {
  description = "Map of connection notification configuration"
  type = map(object({
    connection_notification_arn = string
    connection_events           = list(string)
    vpc_endpoint_id             = optional(string)
    vpc_endpoint_service_id     = optional(string)
  }))
}
