#######################
# variables.tf
#######################

# Prefix List
variable "prefix_list_name" {
  description = "Name of the managed prefix list"
  type        = string
}

variable "address_family" {
  description = "Address family (IPv4 or IPv6)"
  type        = string
}

variable "max_entries" {
  description = "Maximum number of entries allowed in the prefix list"
  type        = number
}

variable "entry_cidr" {
  description = "CIDR block for the prefix list entry"
  type        = string
}

variable "entry_description" {
  description = "Description of the prefix list entry"
  type        = string
}

variable "prefix_list_entry_cidr" {
  description = "CIDR for managed prefix list entry"
  type        = string
}

variable "prefix_list_entry_description" {
  description = "Description of the prefix list entry"
  type        = string
}

variable "prefix_list_id" {
  description = "ID of the managed prefix list"
  type        = string
}

# Network Insights
variable "path_source" {
  description = "Source resource for network insights path"
  type        = string
}

variable "path_destination" {
  description = "Destination resource for network insights path"
  type        = string
}

variable "path_protocol" {
  description = "Protocol for the network insights path"
  type        = string
}

variable "path_destination_port" {
  description = "Destination port for the network insights path"
  type        = number
}

variable "network_insights_path_id" {
  description = "ID of the network insights path"
  type        = string
}

variable "filter_in_arns" {
  description = "List of ARNs to filter in for network insights analysis"
  type        = list(string)
}

variable "wait_for_completion" {
  description = "Whether to wait for completion of the analysis"
  type        = bool
}

# Subnet CIDR Reservation
variable "subnet_cidr_block" {
  description = "CIDR block for the subnet reservation"
  type        = string
}

variable "reservation_type" {
  description = "Type of reservation (explicit or prefix)"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "subnet_cidr_description" {
  description = "Description for the subnet CIDR reservation"
  type        = string
}

# Traffic Mirroring
variable "mirror_filter_description" {
  description = "Description for traffic mirror filter"
  type        = string
}

variable "mirror_filter_id" {
  description = "ID of the traffic mirror filter"
  type        = string
}

variable "traffic_direction" {
  description = "Direction of traffic to mirror (ingress or egress)"
  type        = string
}

variable "rule_action" {
  description = "Action to take on matched traffic (accept or reject)"
  type        = string
}

variable "dest_cidr_block" {
  description = "Destination CIDR block for mirror rule"
  type        = string
}

variable "source_cidr_block" {
  description = "Source CIDR block for mirror rule"
  type        = string
}

variable "dest_port_to" {
  description = "Destination port range end"
  type        = number
}

variable "source_port_to" {
  description = "Source port range end"
  type        = number
}

variable "mirror_target_interface_id" {
  description = "Network interface ID for mirror target"
  type        = string
}

variable "mirror_target_nlb_arn" {
  description = "NLB ARN for mirror target"
  type        = string
}

variable "mirror_session_interface_id" {
  description = "Interface ID for mirror session"
  type        = string
}

variable "mirror_session_filter_id" {
  description = "Filter ID for mirror session"
  type        = string
}

variable "mirror_session_target_id" {
  description = "Target ID for mirror session"
  type        = string
}

variable "mirror_session_number" {
  description = "Session number for traffic mirror session"
  type        = number
}

variable "mirror_session_description" {
  description = "Description of mirror session"
  type        = string
}

variable "mirror_session_packet_length" {
  description = "Packet length for mirror session"
  type        = number
}

variable "mirror_session_vnid" {
  description = "Virtual network ID for mirror session"
  type        = number
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "path_source_port" {
  description = "Source port for network insights path"
  type        = number
}

variable "mirror_filter_network_interface_id" {
  description = "Network Interface ID for traffic mirror filter"
  type        = string
}

variable "rule_direction" {
  description = "Direction of traffic mirror filter rule (ingress or egress)"
  type        = string
}

variable "rule_number" {
  description = "Rule number for traffic mirror filter rule"
  type        = number
}

variable "rule_protocol" {
  description = "Protocol for traffic mirror filter rule"
  type        = number
}

variable "dest_port_from" {
  description = "Starting port for destination port range"
  type        = number
}

variable "source_port_from" {
  description = "Starting port for source port range"
  type        = number
}

variable "mirror_target_gwlb_endpoint_id" {
  type        = string
  description = "Gateway Load Balancer endpoint ID for mirror target"
}