################################################################################
# Internet Gateway Route Table - Outputs
################################################################################

output "internet_gw_route_table_id" {
  description = "ID of the Internet Gateway route table"
  value       = aws_route_table.internet_gw_rtb[0].id
}
