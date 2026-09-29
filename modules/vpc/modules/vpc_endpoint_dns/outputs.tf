output "private_dns_endpoints" {
  description = "Map of VPC endpoint IDs with private DNS settings"
  value       = { for k, v in var.private_dns_settings : k => v.vpc_endpoint_id }
}

output "verified_service_ids" {
  description = "Map of service IDs with DNS verification"
  value       = { for k, v in var.dns_verifications : k => v.service_id }
}

