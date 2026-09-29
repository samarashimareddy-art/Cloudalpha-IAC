################################################################################
# Virtual Private Gateway Route Table - Outputs
################################################################################

output "virtual_private_gw_rtb_id" {
  description = "The ID of the Virtual Private Gateway route table"
  value       = aws_route_table.virtual_private_gw_rtb[0].id
}
