################################################################################
# Public Route Table - Outputs
################################################################################

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}

output "public_route_table_arn" {
  description = "The ARN of the public route table"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].arn : null
}
