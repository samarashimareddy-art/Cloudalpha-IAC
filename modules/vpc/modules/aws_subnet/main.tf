# Public Subnets
resource "aws_subnet" "public" {
  for_each = {
    for subnet in var.public_subnets :
    "${subnet.availability_zone}-${subnet.cidr_block}" => subnet
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  # Optional IPv6 support
  ipv6_cidr_block                                = try(each.value.ipv6_cidr_block, null)
  assign_ipv6_address_on_creation                = try(each.value.assign_ipv6_address_on_creation, null)
  enable_dns64                                   = try(each.value.enable_dns64, null)
  map_public_ip_on_launch                        = try(each.value.map_public_ip_on_launch, null)
  enable_resource_name_dns_a_record_on_launch    = try(each.value.enable_resource_name_dns_a_record_on_launch, null)
  enable_resource_name_dns_aaaa_record_on_launch = try(each.value.enable_resource_name_dns_aaaa_record_on_launch, null)

  tags = merge(var.tags, { "Type" = "public" })
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = {
    for subnet in var.private_subnets :
    "${subnet.availability_zone}-${subnet.cidr_block}" => subnet
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  # Optional IPv6 support
  ipv6_cidr_block                                = try(each.value.ipv6_cidr_block, null)
  assign_ipv6_address_on_creation                = try(each.value.assign_ipv6_address_on_creation, null)
  enable_dns64                                   = try(each.value.enable_dns64, null)
  map_public_ip_on_launch                        = try(each.value.map_public_ip_on_launch, null)
  enable_resource_name_dns_a_record_on_launch    = try(each.value.enable_resource_name_dns_a_record_on_launch, null)
  enable_resource_name_dns_aaaa_record_on_launch = try(each.value.enable_resource_name_dns_aaaa_record_on_launch, null)

  tags = merge(var.tags, { "Type" = "private" })
}
