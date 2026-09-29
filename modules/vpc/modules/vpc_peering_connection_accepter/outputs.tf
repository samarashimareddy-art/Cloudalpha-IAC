output "peering_accepter_ids" {
  description = "Map of VPC peering accepter connection IDs"
  value       = { for k, v in aws_vpc_peering_connection_accepter.this : k => v.id }
}

output "peering_connection_options_ids" {
  description = "Map of VPC peering connection options IDs"
  value       = { for k, v in aws_vpc_peering_connection_options.this : k => v.id }
}
