################################################################################
# Internet Gateway
################################################################################
locals {
  public_subnets_length = length(var.public_subnets)
  vpc_id                = var.vpc_id
}

resource "aws_internet_gateway" "this" {
  count = var.create_vpc && var.create_igw && local.public_subnets_length > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(var.igw_tags, var.general_tags)
}