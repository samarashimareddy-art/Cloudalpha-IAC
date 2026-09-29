################################################################################
# Egress Only Internet Gateway
################################################################################
locals {
  private_subnets_length = length(var.private_subnets)
  vpc_id                 = var.vpc_id
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create_vpc && var.create_egress_only_igw && var.enable_ipv6 && local.private_subnets_length > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(var.egress_only_igw_tags, var.general_tags)
}