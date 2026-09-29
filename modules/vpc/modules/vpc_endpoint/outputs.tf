output "vpc_endpoint_ids" {
  description = "Map of VPC endpoint IDs"
  value = {
    for k, v in aws_vpc_endpoint.this : k => v.id
  }
}

output "vpc_endpoint_dns_entries" {
  description = "DNS entries for the endpoints"
  value = {
    for k, v in aws_vpc_endpoint.this : k => v.dns_entry
  }
}

output "vpc_endpoint_service_ids" {
  description = "Map of VPC endpoint service IDs"
  value       = { for k, v in aws_vpc_endpoint_service.this : k => v.id }
}
