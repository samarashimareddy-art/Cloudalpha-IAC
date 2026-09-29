output "vpc_peering_connection_ids" {
  description = "Map of VPC peering connection IDs"
  value       = { for k, v in aws_vpc_peering_connection.this : k => v.id }
}
