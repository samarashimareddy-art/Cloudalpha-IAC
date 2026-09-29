output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [for s in aws_subnet.private : s.id]
}

output "public_subnet_arns" {
  description = "ARNs of the public subnets"
  value       = [for s in aws_subnet.public : s.arn]
}

output "private_subnet_arns" {
  description = "ARNs of the private subnets"
  value       = [for s in aws_subnet.private : s.arn]
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the public subnets"
  value       = [for s in aws_subnet.public : s.cidr_block]
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnets"
  value       = [for s in aws_subnet.private : s.cidr_block]
}
