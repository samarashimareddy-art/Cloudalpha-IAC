################################################################################
# Internet gateway route table
################################################################################

resource "aws_route_table" "internet_gw_rtb" {
  count = var.create_vpc && var.create_igw ? 1 : 0

  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.create_vpc && var.create_igw ? var.internet_gw_route_table_routes : {}
    content {
      # One of the following destinations must be provided
      cidr_block                 = try(route.value.cidr_block, null)
      ipv6_cidr_block            = try(route.value.cidr_block, null) == null ? try(route.value.ipv6_cidr_block, null) : null
      destination_prefix_list_id = try(route.value.cidr_block, null) == null && try(route.value.ipv6_cidr_block, null) == null ? try(route.value.destination_prefix_list_id, null) : null

      # One of the following targets must be provided
      network_interface_id = try(route.value.network_interface_id, null)
      vpc_endpoint_id      = try(route.value.vpc_endpoint_id, null) #Provide Gateway load balancer endpoint
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
  }

  tags = merge(var.internet_gw_route_table_tags, var.general_tags)
}