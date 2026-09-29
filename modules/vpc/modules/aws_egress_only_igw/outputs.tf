output "egress_only_internet_gateway_id" {
  description = "ID of the egress-only internet gateway"
  value       = try(aws_egress_only_internet_gateway.this[0].id, null)
}
