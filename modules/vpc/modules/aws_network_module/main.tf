resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tags = var.tags
}

# Removed inline ingress/egress to avoid conflict with aws_network_acl_rule

resource "aws_network_acl_association" "this" {
  network_acl_id = var.network_acl_id
  subnet_id      = var.subnet_association_subnet_id
}

resource "aws_network_acl_rule" "this" {
  network_acl_id  = var.network_acl_id
  rule_number     = var.rule_number
  egress          = var.egress
  protocol        = var.rule_protocol
  rule_action     = var.rule_action
  cidr_block      = var.cidr_block
  from_port       = var.from_port
  to_port         = var.to_port
  ipv6_cidr_block = var.ipv6_cidr_block
  icmp_code       = var.icmp_code
  icmp_type       = var.icmp_type
}

resource "aws_network_interface" "this" {
  subnet_id                 = var.subnet_id
  description               = var.description
  enable_primary_ipv6       = var.enable_primary_ipv6
  interface_type            = var.interface_type != null ? var.interface_type : null
  ipv4_prefix_count         = var.ipv4_prefixes == null ? var.ipv4_prefix_count : null
  ipv4_prefixes             = var.ipv4_prefix_count == null ? var.ipv4_prefixes : null
  ipv6_address_count        = var.ipv6_addresses == null && var.ipv6_address_list == null ? var.ipv6_address_count : null
  ipv6_address_list_enabled = var.ipv6_address_list_enabled
  ipv6_address_list         = var.ipv6_address_count == null && var.ipv6_addresses == null ? var.ipv6_address_list : null
  ipv6_addresses            = var.ipv6_address_count == null && var.ipv6_address_list == null ? var.ipv6_addresses : null
  ipv6_prefix_count         = var.ipv6_prefixes == null ? var.ipv6_prefix_count : null
  ipv6_prefixes             = var.ipv6_prefix_count == null ? var.ipv6_prefixes : null
  private_ip_list_enabled   = var.private_ip_list_enabled
  private_ip_list           = var.private_ips == null && var.private_ips_count == null ? var.private_ip_list : null
  private_ips               = var.private_ip_list == null ? var.private_ips : null
  private_ips_count         = var.private_ip_list == null ? var.private_ips_count : null
  security_groups           = var.security_groups
  source_dest_check         = var.source_dest_check
  tags                      = var.tags

  dynamic "attachment" {
    for_each = var.attach_network_interface ? [1] : []
    content {
      instance     = var.instance_id
      device_index = var.device_index
    }
  }
}

# Removed aws_network_interface_attachment since it's already handled by the dynamic attachment block

resource "aws_network_interface_permission" "this" {
  network_interface_id = aws_network_interface.this.id
  aws_account_id       = var.account_id
  permission           = var.permission
}

resource "aws_network_interface_sg_attachment" "this" {
  network_interface_id = aws_network_interface.this.id
  security_group_id    = var.additional_sg_id
}
