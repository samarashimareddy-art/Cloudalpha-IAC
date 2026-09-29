###############################
# aws_vpc_peering_connection
###############################
resource "aws_vpc_peering_connection" "this" {
  for_each = var.peering_connections

  peer_owner_id = try(each.value.peer_owner_id, null)
  peer_vpc_id   = each.value.peer_vpc_id
  vpc_id        = each.value.vpc_id
  peer_region   = try(each.value.peer_region, null)
  auto_accept   = try(each.value.auto_accept, null)

  accepter {
    allow_remote_vpc_dns_resolution = try(each.value.accepter_allow_remote_vpc_dns_resolution, null)
  }

  requester {
    allow_remote_vpc_dns_resolution = try(each.value.requester_allow_remote_vpc_dns_resolution, null)
  }

  tags = merge(var.peering_tags, {
    Name = each.key
  })
}
