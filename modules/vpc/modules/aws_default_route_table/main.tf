################################################################################
# Default route table/ Main route table
################################################################################

resource "aws_default_route_table" "default" {
  count = var.create_vpc && var.manage_default_route_table ? 1 : 0

  default_route_table_id = var.default_route_table_id
  propagating_vgws       = var.default_route_table_propagating_vgws

  dynamic "route" {
    for_each = var.default_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block                 = try(route.value.cidr_block, null)
      ipv6_cidr_block            = try(route.value.ipv6_cidr_block, null)
      destination_prefix_list_id = try(route.value.destination_prefix_list_id, null)

      # One of the following targets must be provided
      core_network_arn          = try(route.value.core_network_arn, null)
      egress_only_gateway_id    = try(route.value.internal_egress_only_igw, false) && var.create_egress_only_igw && var.enable_ipv6 ? aws_egress_only_internet_gateway.this[0].id : try(route.value.egress_only_gateway_id, null)
      gateway_id                = try(route.value.internal_igw, false) && var.create_igw && var.public_subnets_length > 0 ? aws_internet_gateway.this[0].id : try(route.value.gateway_id, null)
      nat_gateway_id            = try(route.value.internal_public_nat_gateway, false) && var.create_vpc && var.enable_public_nat_gateway ? aws_nat_gateway.public_nat_gateway[0].id : try(route.value.internal_private_nat_gateway, false) && var.create_vpc && var.enable_private_nat_gateway ? aws_nat_gateway.private_nat_gateway[0].id : try(route.value.nat_gateway_id, null)
      network_interface_id      = try(route.value.network_interface_id, null)
      transit_gateway_id        = try(route.value.transit_gateway_id, null)
      vpc_endpoint_id           = try(route.value.vpc_endpoint_id, null)
      vpc_peering_connection_id = try(route.value.vpc_peering_connection_id, null)
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
  }

  tags = merge(var.default_route_table_tags, var.general_tags)
}