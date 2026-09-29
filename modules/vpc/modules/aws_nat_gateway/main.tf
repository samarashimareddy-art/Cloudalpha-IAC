################################################################################
# NAT Gateway
################################################################################
locals {
  # Count of public NAT gateways to create
  public_nat_gateway_count = var.single_public_nat_gateway ? 1 : length(var.public_subnets)

  # Count of private NAT gateways to create
  private_nat_gateway_count = var.single_private_nat_gateway ? 1 : length(var.private_subnets)

  # Allocate public NAT EIPs if not reusing existing ones
  public_nat_gateway_ips = var.reuse_public_nat_eips ? var.external_public_nat_eips : try(aws_eip.public_nat_eip[*].id, [])

  # Subnet ID list references (optional if needed for your code context)
  public_subnet_ids  = var.public_subnets
  private_subnet_ids = var.private_subnets
}

################### Public NAT Gateway #########################################
resource "aws_eip" "public_nat_eip" {
  count = var.create_vpc && var.enable_public_nat_gateway && var.reuse_public_nat_eips == false ? local.public_nat_gateway_count : 0

  tags = merge(var.public_nat_eip_tags, var.general_tags)
}

resource "aws_nat_gateway" "public_nat_gateway" {
  count = var.create_vpc && var.enable_public_nat_gateway ? local.public_nat_gateway_count : 0

  allocation_id = element(
    local.public_nat_gateway_ips,
    var.single_public_nat_gateway ? 0 : count.index,
  )

  connectivity_type = "public"

  subnet_id = element(
    var.public_subnets,
    var.single_public_nat_gateway ? 0 : count.index,
  )

  private_ip = var.assign_custom_privateIP_to_public_nat_gw ? element(
    var.public_nat_gw_private_ip,
    var.single_public_nat_gateway ? 0 : count.index,
  ) : null

  tags = merge(var.public_nat_gateway_tags, var.general_tags)

}

################### Private NAT Gateway #########################################
resource "aws_nat_gateway" "private_nat_gateway" {
  count = var.create_vpc && var.enable_private_nat_gateway ? local.private_nat_gateway_count : 0

  connectivity_type = "private"

  private_ip = var.assign_custom_privateIP_to_private_nat_gw ? element(
    var.private_nat_gw_private_ip,
    var.single_private_nat_gateway ? 0 : count.index,
  ) : null

  subnet_id = element(
    var.public_subnets,
    var.single_private_nat_gateway ? 0 : count.index,
  )

  tags = merge({ "Name" = "${var.private_nat_gateway_tags[count.index]["name"]}" }, var.general_tags)

}