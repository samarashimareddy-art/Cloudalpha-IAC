###############################
# aws_vpc_peering_connection_accepter
###############################
resource "aws_vpc_peering_connection_accepter" "this" {
  for_each = var.peering_connection_accepters

  vpc_peering_connection_id = each.value.vpc_peering_connection_id
  auto_accept               = each.value.auto_accept

  accepter {
    allow_remote_vpc_dns_resolution = each.value.accepter_allow_remote_vpc_dns_resolution
  }

  requester {
    allow_remote_vpc_dns_resolution = each.value.requester_allow_remote_vpc_dns_resolution
  }

  tags = merge(var.accepter_tags, {
    Name = each.key
  })
}

###############################
# aws_vpc_peering_connection_options
###############################
resource "aws_vpc_peering_connection_options" "this" {
  for_each = var.peering_connection_options

  vpc_peering_connection_id = each.value.vpc_peering_connection_id

  accepter {
    allow_remote_vpc_dns_resolution = each.value.accepter_allow_remote_vpc_dns_resolution
  }

  requester {
    allow_remote_vpc_dns_resolution = each.value.requester_allow_remote_vpc_dns_resolution
  }
}
