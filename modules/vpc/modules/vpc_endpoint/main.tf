###############################
# aws_vpc_endpoint
###############################
resource "aws_vpc_endpoint" "this" {
  for_each = var.create_endpoint && length(var.endpoints) > 0 ? var.endpoints : {}

  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type
  auto_accept       = try(each.value.auto_accept, null)

  security_group_ids = try(each.value.vpc_endpoint_type, "Interface") == "Interface" ? try(each.value.security_group_ids, []) : []
  subnet_ids         = try(each.value.vpc_endpoint_type, "Interface") == "Interface" ? try(each.value.subnet_ids, []) : []
  route_table_ids    = try(each.value.vpc_endpoint_type, "Gateway") == "Gateway" ? try(each.value.route_table_ids, []) : []

  policy              = try(each.value.policy, null)
  private_dns_enabled = try(each.value.private_dns_enabled, false)
  ip_address_type     = try(each.value.ip_address_type, null)

  dns_options {
    dns_record_ip_type = try(each.value.dns_record_ip_type, null)
  }

  tags = merge({
    Name = each.key
  }, var.endpoint_tags, var.general_tags)

  timeouts {
    create = lookup(var.endpoint_timeouts, "create", "10m")
    update = lookup(var.endpoint_timeouts, "update", "10m")
    delete = lookup(var.endpoint_timeouts, "delete", "10m")
  }
}

###############################
# main.tf - aws_vpc_endpoint_service
###############################

resource "aws_vpc_endpoint_service" "this" {
  for_each = var.endpoint_services

  acceptance_required        = try(each.value.acceptance_required, true)
  network_load_balancer_arns = each.value.network_load_balancer_arns
  gateway_load_balancer_arns = try(each.value.gateway_load_balancer_arns, [])
  allowed_principals         = try(each.value.allowed_principals, [])
  private_dns_name           = try(each.value.private_dns_name, null)
  supported_ip_address_types = try(each.value.supported_ip_address_types, [])

  tags = merge({
    Name = each.key
  }, var.service_tags)
}