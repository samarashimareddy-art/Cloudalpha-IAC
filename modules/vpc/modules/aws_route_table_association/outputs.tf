output "public_route_table_association_ids" {
  description = "List of IDs for public route table associations"
  value       = aws_route_table_association.public[*].id
}

output "private_route_table_association_ids" {
  description = "List of IDs for private route table associations"
  value       = aws_route_table_association.private[*].id
}


