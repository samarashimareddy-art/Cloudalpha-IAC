################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = var.create_vpc && var.vpc != null ? 1 : 0

  cidr_block                       = try(var.vpc.use_ipv6_ipam_pool, false) ? null : try(var.vpc.ipv4_cidr, null)
  ipv4_ipam_pool_id                = try(var.vpc.use_ipv4_ipam_pool, false) ? try(var.vpc.ipv4_ipam_pool_id, null) : null
  ipv4_netmask_length              = try(var.vpc.use_ipv4_ipam_pool, false) ? try(var.vpc.ipv4_netmask_length, null) : null
  assign_generated_ipv6_cidr_block = try(var.vpc.enable_ipv6, false) && try(var.vpc.use_ipv6_ipam_pool, false) == false && try(var.vpc.amazon_provided_ipv6_cidr_block, false) == true ? true : false
  ipv6_cidr_block                  = try(var.vpc.enable_ipv6, false) && try(var.vpc.use_ipv6_ipam_pool, false) == false && try(var.vpc.amazon_provided_ipv6_cidr_block, false) == false ? try(var.vpc.ipv6_cidr, null) : null
  ipv6_ipam_pool_id                = try(var.vpc.enable_ipv6, false) && try(var.vpc.use_ipv4_ipam_pool, false) ? try(var.vpc.ipv6_ipam_pool_id, null) : null
  ipv6_netmask_length              = try(var.vpc.enable_ipv6, false) && try(var.vpc.use_ipv4_ipam_pool, false) ? try(var.vpc.ipv6_netmask_length, null) : null
  instance_tenancy                 = try(var.vpc.instance_tenancy, "default")
  enable_dns_hostnames             = try(var.vpc.enable_dns_hostnames, false)
  enable_dns_support               = try(var.vpc.enable_dns_support, true)

  tags = merge({ "Name" = var.vpc.name }, var.vpc_tags, var.general_tags)
}

########################### Associate secondary cidr blocks to vpc ############
resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  # Do not turn this into `local.vpc_id`
  vpc_id     = aws_vpc.this[0].id
  cidr_block = element(var.secondary_cidr_blocks, count.index)
}