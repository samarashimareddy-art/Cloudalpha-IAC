################################################################################
# Complete VPC Module - Wrapper for all VPC networking components
################################################################################

locals {
  vpc_id = var.create_vpc ? try(module.vpc_core.vpc_id, null) : var.existing_vpc_id

  # Process subnets to extract IDs for other modules
  public_subnet_ids  = var.create_subnets ? module.subnets[0].public_subnet_ids : []
  private_subnet_ids = var.create_subnets ? module.subnets[0].private_subnet_ids : []
}

################################################################################
# VPC Core
################################################################################

module "vpc_core" {
  source = "./modules/vpc_core"

  create_vpc            = var.create_vpc
  vpc                   = var.vpc_config
  vpc_tags              = var.vpc_tags
  secondary_cidr_blocks = var.secondary_cidr_blocks
  general_tags          = var.general_tags
}

################################################################################
# Subnets
################################################################################

module "subnets" {
  count  = var.create_subnets ? 1 : 0
  source = "./modules/aws_subnet"

  vpc_id          = local.vpc_id
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.general_tags
}

################################################################################
# Internet Gateway
################################################################################

module "internet_gateway" {
  count  = var.create_internet_gateway ? 1 : 0
  source = "./modules/aws_internet_gateway"

  create_vpc     = var.create_vpc
  create_igw     = var.create_internet_gateway
  vpc_id         = local.vpc_id
  public_subnets = local.public_subnet_ids
  igw_tags       = var.internet_gateway_tags
  general_tags   = var.general_tags
}

################################################################################
# NAT Gateway
################################################################################

module "nat_gateway" {
  count  = var.create_nat_gateway ? 1 : 0
  source = "./modules/aws_nat_gateway"

  create_vpc                                = var.create_vpc
  enable_public_nat_gateway                 = var.enable_public_nat_gateway
  enable_private_nat_gateway                = var.enable_private_nat_gateway
  single_public_nat_gateway                 = var.single_public_nat_gateway
  single_private_nat_gateway                = var.single_private_nat_gateway
  public_subnets                            = local.public_subnet_ids
  private_subnets                           = local.private_subnet_ids
  reuse_public_nat_eips                     = var.reuse_public_nat_eips
  external_public_nat_eips                  = var.external_public_nat_eips
  assign_custom_privateIP_to_public_nat_gw  = var.assign_custom_privateIP_to_public_nat_gw
  public_nat_gw_private_ip                  = var.public_nat_gw_private_ip
  assign_custom_privateIP_to_private_nat_gw = var.assign_custom_privateIP_to_private_nat_gw
  private_nat_gw_private_ip                 = var.private_nat_gw_private_ip
  public_nat_eip_tags                       = var.public_nat_eip_tags
  public_nat_gateway_tags                   = var.public_nat_gateway_tags
  private_nat_gateway_tags                  = var.private_nat_gateway_tags
  general_tags                              = var.general_tags
}

################################################################################
# Public Route Tables
################################################################################

module "public_route_table" {
  count  = var.create_public_route_table ? 1 : 0
  source = "./modules/aws_route_table_public"

  create_vpc                = var.create_vpc
  create_igw                = var.create_internet_gateway
  create_egress_only_igw    = false
  enable_ipv6               = false
  vpc_id                    = local.vpc_id
  public_subnets            = local.public_subnet_ids
  internet_gateway_id       = var.create_internet_gateway ? module.internet_gateway[0].internet_gateway_id : null
  public_route_table_routes = var.public_route_table_routes
  public_route_table_tags   = var.public_route_table_tags
  general_tags              = var.general_tags
}

################################################################################
# Private Route Tables
################################################################################

module "private_route_table" {
  count  = var.create_private_route_table ? 1 : 0
  source = "./modules/aws_route_table_private"

  create_vpc                           = var.create_vpc
  vpc_id                               = local.vpc_id
  private_subnets                      = local.private_subnet_ids
  private_subnets_length               = length(var.private_subnets)
  public_subnets_length                = length(var.public_subnets)
  private_route_tables                 = var.private_route_tables
  private_route_table_routes           = var.private_route_table_routes
  private_route_table_propagating_vgws = var.private_route_table_propagating_vgws
  private_route_table_tags             = var.private_route_table_tags
  create_egress_only_igw               = false
  enable_ipv6                          = false
  create_igw                           = var.create_internet_gateway
  enable_public_nat_gateway            = var.enable_public_nat_gateway
  enable_private_nat_gateway           = var.enable_private_nat_gateway
  public_nat_gateway_ids               = var.create_nat_gateway && var.enable_public_nat_gateway ? module.nat_gateway[0].public_nat_gateway_ids : []
  private_nat_gateway_ids              = var.create_nat_gateway && var.enable_private_nat_gateway ? module.nat_gateway[0].private_nat_gateway_ids : []
  general_tags                         = var.general_tags
}

################################################################################
# Route Table Associations
################################################################################

module "route_table_association" {
  count  = var.create_route_table_associations ? 1 : 0
  source = "./modules/aws_route_table_association"

  create_vpc            = var.create_vpc
  create_igw            = var.create_internet_gateway
  enable_vpn_gateway    = false
  public_subnets        = local.public_subnet_ids
  private_subnets       = local.private_subnet_ids
  public_route_table_id = var.create_public_route_table ? module.public_route_table[0].public_route_table_id : var.external_public_route_table_id
  private_route_tables  = var.create_private_route_table ? module.private_route_table[0].private_route_table_ids : var.external_private_route_table_ids
}

################################################################################
# Network ACLs
################################################################################

module "network_acl" {
  count  = var.create_network_acl ? 1 : 0
  source = "./modules/aws_network_acl"

  vpc_id                        = local.vpc_id
  create_vpc                    = var.create_vpc
  public_dedicated_network_acl  = var.public_dedicated_network_acl
  private_dedicated_network_acl = var.private_dedicated_network_acl
  public_subnets                = local.public_subnet_ids
  private_subnets               = local.private_subnet_ids
  public_network_acl_ingress    = var.public_network_acl_ingress
  public_network_acl_egress     = var.public_network_acl_egress
  private_network_acl_ingress   = var.private_network_acl_ingress
  private_network_acl_egress    = var.private_network_acl_egress
  public_acl_tags               = var.public_acl_tags
  private_acl_tags              = var.private_acl_tags
  general_tags                  = var.general_tags
}

################################################################################
# VPC Flow Logs
################################################################################

module "flow_logs" {
  count  = var.enable_flow_logs ? 1 : 0
  source = "./modules/flow-logs"

  vpc_id                        = local.vpc_id
  traffic_type                  = var.flow_log_traffic_type
  log_destination_type          = var.flow_log_destination_type
  log_destination               = var.flow_log_destination_arn
  log_format                    = var.flow_log_format
  create_iam_role               = var.flow_log_create_iam_role
  iam_role_arn                  = var.flow_log_iam_role_arn
  deliver_cross_account_role    = var.flow_log_deliver_cross_account_role
  max_aggregation_interval      = var.flow_log_max_aggregation_interval
  destination_options           = var.flow_log_destination_options
  create_log_group              = var.flow_log_create_log_group
  log_group_name                = var.flow_log_log_group_name
  log_group_retention_days      = var.flow_log_log_group_retention_days
  role_name                     = var.flow_log_role_name
  policy_name                   = var.flow_log_policy_name
  tags                          = var.general_tags
}

################################################################################
# Default VPC Management
################################################################################

module "default_vpc" {
  count  = var.manage_default_vpc ? 1 : 0
  source = "./modules/default_vpc"

  manage_default_vpc               = var.manage_default_vpc
  default_vpc_enable_dns_support   = var.default_vpc_enable_dns_support
  default_vpc_enable_dns_hostnames = var.default_vpc_enable_dns_hostnames
  default_vpc_tags                 = var.default_vpc_tags
  general_tags                     = var.general_tags
}