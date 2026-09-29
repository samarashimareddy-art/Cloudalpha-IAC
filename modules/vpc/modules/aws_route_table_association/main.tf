locals {
  # VPC creation toggle
  create_vpc = var.create_vpc

  # Length of public subnets
  public_subnets_length = length(var.public_subnets)

  # Length of private subnets
  private_subnets_length = length(var.private_subnets)

  # Boolean indicating if Internet Gateway should be created
  create_igw = var.create_igw

  # Boolean indicating if VPN Gateway should be enabled
  enable_vpn_gateway = var.enable_vpn_gateway

  # Length of private route tables
  private_route_tables_length = length(var.private_route_tables)
}


################################################################################
# Route table association
################################################################################

resource "aws_route_table_association" "public" {
  count = var.create_vpc && local.public_subnets_length > 0 ? local.public_subnets_length : 0

  subnet_id      = element(var.public_subnets, count.index)
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc && local.private_subnets_length > 0 && length(var.private_route_tables) > 0 ? local.private_subnets_length : 0

  subnet_id      = element(var.private_subnets, count.index)
  route_table_id = element(var.private_route_tables, count.index)
}
