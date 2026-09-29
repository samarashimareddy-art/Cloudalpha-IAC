output "network_acl_id" {
  description = "ID of the network ACL"
  value       = aws_network_acl.this.id
}

output "network_interface_id" {
  description = "ID of the created network interface"
  value       = aws_network_interface.this.id
}

output "network_interface_arn" {
  description = "ARN of the created network interface"
  value       = aws_network_interface.this.arn
}

output "network_interface_private_ips" {
  description = "Private IP addresses assigned to the ENI"
  value       = aws_network_interface.this.private_ips
}

output "network_interface_mac_address" {
  description = "MAC address of the ENI"
  value       = aws_network_interface.this.mac_address
}

output "network_acl_rule_id" {
  description = "ID of the created network ACL rule"
  value       = aws_network_acl_rule.this.id
}

output "eni_permission_network_interface_id" {
  description = "Network Interface ID associated with the permission"
  value       = aws_network_interface_permission.this.network_interface_id
}

output "eni_permission_account_id" {
  description = "AWS Account ID for the ENI permission"
  value       = aws_network_interface_permission.this.aws_account_id
}

output "eni_permission_type" {
  description = "Permission type (e.g., INSTANCE-ATTACH)"
  value       = aws_network_interface_permission.this.permission
}

output "eni_sg_attachment_id" {
  description = "ID of the ENI SG attachment"
  value       = aws_network_interface_sg_attachment.this.id
}
