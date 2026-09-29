variable "peering_connections" {
  description = "Map of VPC peering connections to create"
  type = map(object({
    peer_owner_id                             = optional(string)
    peer_vpc_id                               = string
    vpc_id                                    = string
    peer_region                               = optional(string)
    auto_accept                               = optional(bool)
    accepter_allow_remote_vpc_dns_resolution  = optional(bool)
    requester_allow_remote_vpc_dns_resolution = optional(bool)
  }))
}

variable "peering_tags" {
  description = "Tags to assign to VPC peering connections"
  type        = map(string)
}
