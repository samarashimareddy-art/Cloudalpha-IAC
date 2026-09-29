output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this[0].arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block assigned to the VPC"
  value       = try(aws_vpc.this[0].ipv6_cidr_block, null)
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table for the VPC"
  value       = try(aws_vpc.this[0].main_route_table_id, null)
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks associated with the VPC"
  value       = [for assoc in aws_vpc_ipv4_cidr_block_association.this : assoc.cidr_block]
}
