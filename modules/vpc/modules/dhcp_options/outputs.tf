################################################################################
# DHCP Options Set - Outputs
################################################################################

output "dhcp_options_id" {
  description = "The ID of the DHCP options set"
  value       = try(aws_vpc_dhcp_options.this[0].id, null)
}

output "dhcp_options_association_id" {
  description = "The ID of the DHCP options association"
  value       = try(aws_vpc_dhcp_options_association.this[0].id, null)
}

output "dhcp_options_domain_name" {
  description = "The domain name configured in the DHCP options"
  value       = try(aws_vpc_dhcp_options.this[0].domain_name, null)
}
