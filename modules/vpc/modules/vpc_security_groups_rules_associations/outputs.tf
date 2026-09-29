output "egress_rule_ids" {
  value = { for k, v in aws_vpc_security_group_egress_rule.this : k => v.security_group_rule_id }
}

output "ingress_rule_ids" {
  value = { for k, v in aws_vpc_security_group_ingress_rule.this : k => v.security_group_rule_id }
}

output "vpc_association_ids" {
  value = { for k, v in aws_vpc_security_group_vpc_association.this : k => v.vpc_id }
}

