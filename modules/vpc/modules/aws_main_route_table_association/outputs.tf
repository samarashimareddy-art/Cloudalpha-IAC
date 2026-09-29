output "id" {
  description = "The ID of the Main Route Table Association"
  value       = aws_main_route_table_association.this.id
}

output "original_route_table_id" {
  description = "The original main route table ID of the VPC"
  value       = aws_main_route_table_association.this.original_route_table_id
}
