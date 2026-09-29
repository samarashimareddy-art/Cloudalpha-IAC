output "default_vpc_id" {
  description = "ID of the default VPC"
  value       = try(aws_default_vpc.this[0].id, null)
}

output "default_vpc_cidr_block" {
  description = "CIDR block of the default VPC"
  value       = try(aws_default_vpc.this[0].cidr_block, null)
}

output "default_vpc_enable_dns_support" {
  description = "Whether DNS support is enabled"
  value       = try(aws_default_vpc.this[0].enable_dns_support, null)
}

output "default_vpc_enable_dns_hostnames" {
  description = "Whether DNS hostnames are enabled"
  value       = try(aws_default_vpc.this[0].enable_dns_hostnames, null)
}
