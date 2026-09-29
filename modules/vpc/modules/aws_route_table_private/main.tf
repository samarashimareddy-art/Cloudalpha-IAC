################################################################################
# Private route tables
################################################################################

resource "aws_route_table" "private" {
  count = var.create_vpc && var.private_subnets_length > 0 ? length(var.private_route_tables) : 0

  vpc_id           = var.vpc_id
  propagating_vgws = var.private_route_table_propagating_vgws

  dynamic "route" {
    for_each = length(var.private_route_table_routes) > count.index ? var.private_route_table_routes[count.index] : []
    content {
      # One of the following destinations must be provided
      cidr_block                 = try(route.value.cidr_block, null)
      ipv6_cidr_block            = try(route.value.cidr_block, null) == null ? try(route.value.ipv6_cidr_block, null) : null
      destination_prefix_list_id = try(route.value.cidr_block, null) == null && try(route.value.ipv6_cidr_block, null) == null ? try(route.value.destination_prefix_list_id, null) : null

      # One of the following targets must be provided
      core_network_arn          = try(route.value.core_network_arn, null)
      egress_only_gateway_id    = try(route.value.egress_only_gateway_id, null)
      gateway_id                = try(route.value.gateway_id, null)
      nat_gateway_id            = try(route.value.internal_public_nat_gateway, false) && length(var.public_nat_gateway_ids) > 0 ? var.public_nat_gateway_ids[0] : try(route.value.internal_private_nat_gateway, false) && length(var.private_nat_gateway_ids) > 0 ? var.private_nat_gateway_ids[0] : try(route.value.nat_gateway_id, null)
      transit_gateway_id        = try(route.value.transit_gateway_id, null)
      vpc_endpoint_id           = try(route.value.vpc_endpoint_id, null)
      vpc_peering_connection_id = try(route.value.vpc_peering_connection_id, null)
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
  }

  tags = merge({ "Name" = "${var.private_route_tables[count.index]["name"]}" }, var.general_tags)
}
