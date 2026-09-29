################################################################################
# Publiс route tables
################################################################################

resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.public_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block                 = try(route.value.cidr_block, null)
      ipv6_cidr_block            = try(route.value.cidr_block, null) == null ? try(route.value.ipv6_cidr_block, null) : null
      destination_prefix_list_id = try(route.value.cidr_block, null) == null && try(route.value.ipv6_cidr_block, null) == null ? try(route.value.destination_prefix_list_id, null) : null

      # One of the following targets must be provided
      core_network_arn          = try(route.value.core_network_arn, null)
      # The gateways are created by sibling modules, so their IDs are passed in
      # (this module previously referenced aws_internet_gateway.this /
      # aws_egress_only_internet_gateway.this, which don't exist in it).
      egress_only_gateway_id    = try(route.value.internal_egress_only_igw, false) && var.create_egress_only_igw && var.enable_ipv6 ? var.egress_only_gateway_id : try(route.value.egress_only_gateway_id, null)
      gateway_id                = try(route.value.internal_igw, false) && var.create_igw && length(var.public_subnets) > 0 ? var.internet_gateway_id : try(route.value.gateway_id, null)
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

  tags = merge(var.public_route_table_tags, var.general_tags)
}