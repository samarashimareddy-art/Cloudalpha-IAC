resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }

  dynamic "timeouts" {
    for_each = var.enable_custom_timeout ? [1] : []
    content {
      delete = var.timeout_delete
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  description       = each.value.description

  cidr_ipv4      = try(each.value.cidr_ipv4, null)
  cidr_ipv6      = try(each.value.cidr_ipv6, null)
  prefix_list_id = try(each.value.prefix_list_id, null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  description       = each.value.description

  cidr_ipv4      = try(each.value.cidr_ipv4, null)
  cidr_ipv6      = try(each.value.cidr_ipv6, null)
  prefix_list_id = try(each.value.prefix_list_id, null)
}
