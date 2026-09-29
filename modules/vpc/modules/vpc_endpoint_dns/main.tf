###############################
# aws_vpc_endpoint_private_dns
###############################
resource "aws_vpc_endpoint_private_dns" "this" {
  for_each = var.private_dns_settings

  vpc_endpoint_id     = each.value["vpc_endpoint_id"]
  private_dns_enabled = each.value["private_dns_enabled"]
}

###############################
# aws_vpc_endpoint_service_private_dns_verification
###############################
resource "aws_vpc_endpoint_service_private_dns_verification" "this" {
  for_each = var.dns_verifications

  service_id            = each.value.service_id
  wait_for_verification = try(each.value.wait_for_verification, true)
}