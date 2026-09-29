output "security_group_rule_ids" {
  description = "Map of security group rule IDs."
  value       = { for k, rule in aws_security_group_rule.this : k => rule.id }
}
