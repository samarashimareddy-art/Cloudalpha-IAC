################################################################################
# Private Route Table - Outputs
################################################################################

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = aws_route_table.private[*].id
}

output "private_route_table_arns" {
  description = "ARNs of the private route tables"
  value       = aws_route_table.private[*].arn
}

output "private_route_table_names" {
  description = "Names of the private route tables"
  value       = [for table in var.private_route_tables : table.name]
}
