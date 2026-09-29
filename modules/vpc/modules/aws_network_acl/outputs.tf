output "public_network_acl_id" {
  description = "The ID of the public network ACL"
  value       = aws_network_acl.public[0].id
}

output "private_network_acl_id" {
  description = "The ID of the private network ACL"
  value       = aws_network_acl.private[0].id
}
