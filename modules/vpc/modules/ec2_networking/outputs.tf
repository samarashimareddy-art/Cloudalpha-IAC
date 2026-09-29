#######################
# outputs.tf
#######################

output "prefix_list_id" {
  value       = aws_ec2_managed_prefix_list.this.id
  description = "ID of the managed prefix list"
}

output "network_insights_path_id" {
  value       = aws_ec2_network_insights_path.this.id
  description = "ID of the network insights path"
}

output "network_insights_analysis_id" {
  value       = aws_ec2_network_insights_analysis.this.id
  description = "ID of the network insights analysis"
}

output "subnet_cidr_reservation_id" {
  value       = aws_ec2_subnet_cidr_reservation.this.id
  description = "ID of the subnet CIDR reservation"
}

output "traffic_mirror_filter_id" {
  value       = aws_ec2_traffic_mirror_filter.this.id
  description = "ID of the traffic mirror filter"
}

output "traffic_mirror_filter_rule_id" {
  value       = aws_ec2_traffic_mirror_filter_rule.this.id
  description = "ID of the traffic mirror filter rule"
}

output "traffic_mirror_target_id" {
  value       = aws_ec2_traffic_mirror_target.this.id
  description = "ID of the traffic mirror target"
}

output "traffic_mirror_session_id" {
  value       = aws_ec2_traffic_mirror_session.this.id
  description = "ID of the traffic mirror session"
}
