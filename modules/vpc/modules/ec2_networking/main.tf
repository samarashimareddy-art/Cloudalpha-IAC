# Prefix List
resource "aws_ec2_managed_prefix_list" "this" {
  name           = var.prefix_list_name
  address_family = var.address_family
  max_entries    = var.max_entries
  entry {
    cidr        = var.entry_cidr
    description = var.entry_description
  }
  tags = var.tags
}

resource "aws_ec2_managed_prefix_list_entry" "this" {
  cidr           = var.prefix_list_entry_cidr
  description    = var.prefix_list_entry_description
  prefix_list_id = var.prefix_list_id
}

# Network Insights
resource "aws_ec2_network_insights_path" "this" {
  source           = var.path_source
  destination      = var.path_destination
  protocol         = var.path_protocol
  destination_port = var.path_destination_port
  #source_port         = var.path_source_port
  tags = var.tags
}

resource "aws_ec2_network_insights_analysis" "this" {
  network_insights_path_id = var.network_insights_path_id
  filter_in_arns           = var.filter_in_arns
  wait_for_completion      = var.wait_for_completion
  tags                     = var.tags
}

# Subnet CIDR Reservation
resource "aws_ec2_subnet_cidr_reservation" "this" {
  cidr_block       = var.subnet_cidr_block
  reservation_type = var.reservation_type
  subnet_id        = var.subnet_id
  description      = var.subnet_cidr_description
}

# Traffic Mirroring
resource "aws_ec2_traffic_mirror_filter" "this" {
  description = var.mirror_filter_description
  #network_interface_id  = var.mirror_filter_network_interface_id
  tags = var.tags
}

resource "aws_ec2_traffic_mirror_filter_rule" "this" {
  traffic_mirror_filter_id = var.mirror_filter_id
  traffic_direction        = var.traffic_direction # accept "ingress" or "egress"
  rule_number              = var.rule_number
  rule_action              = var.rule_action # accept "accept" or "reject"

  destination_cidr_block = var.dest_cidr_block
  protocol               = var.rule_protocol
  source_cidr_block      = var.source_cidr_block

  destination_port_range {
    from_port = var.dest_port_from
    to_port   = var.dest_port_to
  }

  source_port_range {
    from_port = var.source_port_from
    to_port   = var.source_port_to
  }
}

resource "aws_ec2_traffic_mirror_target" "this" {
  network_interface_id              = var.mirror_target_interface_id != null ? var.mirror_target_interface_id : null
  network_load_balancer_arn         = var.mirror_target_nlb_arn != null ? var.mirror_target_nlb_arn : null
  gateway_load_balancer_endpoint_id = var.mirror_target_gwlb_endpoint_id != null ? var.mirror_target_gwlb_endpoint_id : null

  tags = var.tags
}

resource "aws_ec2_traffic_mirror_session" "this" {
  network_interface_id     = var.mirror_session_interface_id
  traffic_mirror_filter_id = var.mirror_session_filter_id
  traffic_mirror_target_id = var.mirror_session_target_id
  session_number           = var.mirror_session_number
  description              = var.mirror_session_description
  packet_length            = var.mirror_session_packet_length
  virtual_network_id       = var.mirror_session_vnid
  tags                     = var.tags
}
