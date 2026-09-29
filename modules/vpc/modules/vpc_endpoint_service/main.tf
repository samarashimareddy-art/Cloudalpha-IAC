###############################
# aws_vpc_endpoint_service
###############################
resource "aws_vpc_endpoint_service" "this" {
  for_each = var.endpoint_services

  acceptance_required        = each.value.acceptance_required
  network_load_balancer_arns = each.value.network_load_balancer_arns
  gateway_load_balancer_arns = try(each.value.gateway_load_balancer_arns, null)
  private_dns_name           = try(each.value.private_dns_name, null)
  supported_ip_address_types = try(each.value.supported_ip_address_types, null)
  supported_regions          = try(each.value.supported_regions, null)
  tags                       = merge(var.service_tags, { Name = each.key })
}

###############################
# aws_vpc_endpoint_service_allowed_principal
###############################
resource "aws_vpc_endpoint_service_allowed_principal" "this" {
  for_each = var.allowed_principals

  vpc_endpoint_service_id = each.value.vpc_endpoint_service_id
  principal_arn           = each.value.principal_arn
}