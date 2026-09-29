output "endpoint_connection_accepter_ids" {
  description = "Map of VPC endpoint connection accepter resource IDs"
  value       = { for k, v in aws_vpc_endpoint_connection_accepter.this : k => v.id }
}

output "endpoint_connection_notification_ids" {
  description = "Map of VPC endpoint connection notification resource IDs"
  value       = { for k, v in aws_vpc_endpoint_connection_notification.this : k => v.id }
}
