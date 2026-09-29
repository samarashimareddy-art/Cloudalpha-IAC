locals {
  # Extract the VPC ID from a variable or data source
  vpc_id = var.vpc_id

  # Calculate the length of public subnets
  public_subnets_length = length(var.public_subnets)

  # Calculate the length of private subnets
  private_subnets_length = length(var.private_subnets)
}


################################################################################
# Public Network ACLs
################################################################################

resource "aws_network_acl" "public" {
  count = var.create_vpc && var.public_dedicated_network_acl && local.public_subnets_length > 0 ? 1 : 0

  vpc_id     = local.vpc_id
  subnet_ids = var.public_subnets

  dynamic "ingress" {
    for_each = var.public_network_acl_ingress
    content {
      rule_no         = ingress.value.rule_no
      action          = ingress.value.action
      cidr_block      = try(ingress.value.cidr_block, null)
      to_port         = ingress.value.to_port
      from_port       = ingress.value.from_port
      protocol        = ingress.value.protocol
      icmp_code       = try(ingress.value.icmp_code, null)
      icmp_type       = try(ingress.value.icmp_type, null)
      ipv6_cidr_block = try(ingress.value.ipv6_cidr_block, null)
    }
  }

  dynamic "egress" {
    for_each = var.public_network_acl_egress
    content {
      rule_no         = egress.value.rule_no
      action          = egress.value.action
      cidr_block      = try(egress.value.cidr_block, null)
      to_port         = egress.value.to_port
      from_port       = egress.value.from_port
      protocol        = egress.value.protocol
      icmp_code       = try(egress.value.icmp_code, null)
      icmp_type       = try(egress.value.icmp_type, null)
      ipv6_cidr_block = try(egress.value.ipv6_cidr_block, null)
    }
  }

  tags = merge(var.public_acl_tags, var.general_tags)
}

################################################################################
# Private Network ACLs
################################################################################

resource "aws_network_acl" "private" {
  count = var.create_vpc && var.private_dedicated_network_acl && local.private_subnets_length > 0 ? 1 : 0

  vpc_id     = local.vpc_id
  subnet_ids = var.private_subnets

  dynamic "ingress" {
    for_each = var.private_network_acl_ingress
    content {
      rule_no         = ingress.value.rule_no
      action          = ingress.value.action
      cidr_block      = try(ingress.value.cidr_block, null)
      to_port         = ingress.value.to_port
      from_port       = ingress.value.from_port
      protocol        = ingress.value.protocol
      icmp_code       = try(ingress.value.icmp_code, null)
      icmp_type       = try(ingress.value.icmp_type, null)
      ipv6_cidr_block = try(ingress.value.ipv6_cidr_block, null)
    }
  }

  dynamic "egress" {
    for_each = var.private_network_acl_egress
    content {
      rule_no         = egress.value.rule_no
      action          = egress.value.action
      cidr_block      = try(egress.value.cidr_block, null)
      to_port         = egress.value.to_port
      from_port       = egress.value.from_port
      protocol        = egress.value.protocol
      icmp_code       = try(egress.value.icmp_code, null)
      icmp_type       = try(egress.value.icmp_type, null)
      ipv6_cidr_block = try(egress.value.ipv6_cidr_block, null)
    }
  }

  tags = merge(var.private_acl_tags, var.general_tags)
}