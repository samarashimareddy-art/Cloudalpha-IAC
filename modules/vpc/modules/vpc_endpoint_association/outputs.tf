output "route_table_association_ids" {
  description = "IDs of VPC endpoint route table associations"
  value = {
    for k, v in aws_vpc_endpoint_route_table_association.this : k => v.id
  }
}

output "security_group_association_ids" {
  description = "IDs of VPC endpoint security group associations"
  value = {
    for k, v in aws_vpc_endpoint_security_group_association.this : k => v.id
  }
}

output "subnet_association_ids" {
  description = "IDs of VPC endpoint subnet associations"
  value = {
    for k, v in aws_vpc_endpoint_subnet_association.this : k => v.id
  }
}
