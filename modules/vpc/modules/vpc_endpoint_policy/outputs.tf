output "vpc_endpoint_policy_ids" {
  description = "Map of VPC endpoint policy resource addresses"
  value       = { for k, v in aws_vpc_endpoint_policy.this : k => v.vpc_endpoint_id }
}
