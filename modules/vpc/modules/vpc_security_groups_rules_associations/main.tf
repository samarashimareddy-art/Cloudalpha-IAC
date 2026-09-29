# Egress Rules
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id            = each.value.security_group_id
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  description                  = each.value.description
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  tags                         = merge(var.default_tags, each.value.tags != null ? each.value.tags : {})
}

# Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules

  security_group_id            = each.value.security_group_id
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  description                  = each.value.description
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  tags                         = merge(var.default_tags, each.value.tags != null ? each.value.tags : {})
}

# VPC Association
resource "aws_vpc_security_group_vpc_association" "this" {
  for_each = var.sg_vpc_associations

  security_group_id = each.value.security_group_id
  vpc_id            = each.value.vpc_id
}
