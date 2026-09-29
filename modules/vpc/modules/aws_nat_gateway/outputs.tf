output "public_nat_gateway_ids" {
  description = "IDs of the created public NAT Gateways"
  value       = aws_nat_gateway.public_nat_gateway[*].id
}

output "public_nat_gateway_ips" {
  description = "Elastic IP allocation IDs for public NAT Gateways"
  value       = local.public_nat_gateway_ips
}

output "private_nat_gateway_ids" {
  description = "IDs of the created private NAT Gateways"
  value       = aws_nat_gateway.private_nat_gateway[*].id
}
