output "vpc_endpoint_service_ids" {
  description = "Map of VPC endpoint service IDs"
  value       = { for k, v in aws_vpc_endpoint_service.this : k => v.id }
}

output "vpc_endpoint_service_allowed_principal_ids" {
  description = "Map of allowed principal IDs"
  value       = { for k, v in aws_vpc_endpoint_service_allowed_principal.this : k => v.id }
}
