################################################################################
# VPC Outputs
################################################################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = local.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = var.create_vpc ? module.vpc_core.vpc_arn : null
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = var.create_vpc ? module.vpc_core.vpc_cidr_block : null
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = var.create_vpc ? module.vpc_core.vpc_ipv6_cidr_block : null
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = var.create_vpc ? module.vpc_core.vpc_main_route_table_id : null
}

################################################################################
# Subnet Outputs
################################################################################

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = local.public_subnet_ids
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = local.private_subnet_ids
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = var.create_subnets ? module.subnets[0].public_subnet_arns : []
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = var.create_subnets ? module.subnets[0].private_subnet_arns : []
}

output "public_subnets_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = var.create_subnets ? module.subnets[0].public_subnet_cidr_blocks : []
}

output "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = var.create_subnets ? module.subnets[0].private_subnet_cidr_blocks : []
}

################################################################################
# Internet Gateway Outputs
################################################################################

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = var.create_internet_gateway ? module.internet_gateway[0].internet_gateway_id : null
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = var.create_internet_gateway ? module.internet_gateway[0].internet_gateway_arn : null
}

################################################################################
# NAT Gateway Outputs
################################################################################

output "public_nat_gateway_ids" {
  description = "List of IDs of the public NAT Gateways"
  value       = var.create_nat_gateway && var.enable_public_nat_gateway ? module.nat_gateway[0].public_nat_gateway_ids : []
}

output "private_nat_gateway_ids" {
  description = "List of IDs of the private NAT Gateways"
  value       = var.create_nat_gateway && var.enable_private_nat_gateway ? module.nat_gateway[0].private_nat_gateway_ids : []
}

output "public_nat_eip_ids" {
  description = "List of allocation IDs of Elastic IPs created for public NAT Gateways"
  value       = var.create_nat_gateway && var.enable_public_nat_gateway ? module.nat_gateway[0].public_nat_gateway_ips : []
}

output "public_nat_eip_public_ips" {
  description = "List of public Elastic IPs created for public NAT Gateways"
  value       = var.create_nat_gateway && var.enable_public_nat_gateway ? module.nat_gateway[0].public_nat_gateway_ips : []
}

################################################################################
# Route Table Outputs
################################################################################

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = var.create_public_route_table ? module.public_route_table[0].public_route_table_id : null
}

output "private_route_table_ids" {
  description = "List of IDs of the private route tables"
  value       = var.create_private_route_table ? module.private_route_table[0].private_route_table_ids : []
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = var.create_route_table_associations ? module.route_table_association[0].public_route_table_association_ids : []
}

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = var.create_route_table_associations ? module.route_table_association[0].private_route_table_association_ids : []
}



################################################################################
# Network ACL Outputs
################################################################################

output "public_network_acl_id" {
  description = "The ID of the public network ACL"
  value       = var.create_network_acl && var.public_dedicated_network_acl ? module.network_acl[0].public_network_acl_id : null
}

output "private_network_acl_id" {
  description = "The ID of the private network ACL"
  value       = var.create_network_acl && var.private_dedicated_network_acl ? module.network_acl[0].private_network_acl_id : null
}

################################################################################
# VPC Flow Logs Outputs
################################################################################

output "flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = var.enable_flow_logs ? module.flow_logs[0].flow_log_id : null
}

output "flow_log_arn" {
  description = "The ARN of the Flow Log"
  value       = var.enable_flow_logs ? module.flow_logs[0].flow_log_arn : null
}

################################################################################
# Default VPC Outputs
################################################################################

output "default_vpc_id" {
  description = "The ID of the default VPC"
  value       = var.manage_default_vpc ? module.default_vpc[0].default_vpc_id : null
}

output "default_vpc_arn" {
  description = "The ARN of the default VPC"
  value       = var.manage_default_vpc ? module.default_vpc[0].default_vpc_arn : null
}