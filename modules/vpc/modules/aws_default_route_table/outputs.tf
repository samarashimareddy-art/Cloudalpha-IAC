output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = try(aws_default_route_table.default[0].id, null)
}

output "default_route_table_arn" {
  description = "ARN of the default route table"
  value       = try(aws_default_route_table.default[0].arn, null)
}
