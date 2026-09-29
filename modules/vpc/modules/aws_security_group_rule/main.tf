resource "aws_security_group_rule" "this" {
  for_each = var.rules

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = each.value.security_group_id

  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
  description              = try(each.value.description, null)
}
