variable "peering_connection_accepters" {
  description = "Map of VPC peering connection accepter configurations"
  type = map(object({
    vpc_peering_connection_id                 = string
    auto_accept                               = optional(bool)
    accepter_allow_remote_vpc_dns_resolution  = optional(bool)
    requester_allow_remote_vpc_dns_resolution = optional(bool)
  }))
  default = {}
}

variable "peering_connection_options" {
  description = "Map of VPC peering connection options configurations"
  type = map(object({
    vpc_peering_connection_id                 = string
    accepter_allow_remote_vpc_dns_resolution  = optional(bool)
    requester_allow_remote_vpc_dns_resolution = optional(bool)
  }))
  default = {}
}

variable "accepter_tags" {
  description = "Tags to assign to the VPC Peering Accepter resources"
  type        = map(string)
  default     = {}
}