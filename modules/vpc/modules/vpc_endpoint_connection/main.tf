###############################
# aws_vpc_endpoint_connection_accepter
###############################
resource "aws_vpc_endpoint_connection_accepter" "this" {
  for_each = var.accept_connections ? var.endpoint_accept_map : {}

  vpc_endpoint_id         = each.value["vpc_endpoint_id"]
  vpc_endpoint_service_id = each.value["vpc_endpoint_service_id"]
  #auto_accept             = lookup(each.value, "auto_accept", true)
}

###############################
# aws_vpc_endpoint_connection_notification
###############################
resource "aws_vpc_endpoint_connection_notification" "this" {
  for_each = var.connection_notifications

  connection_notification_arn = each.value.connection_notification_arn
  connection_events           = each.value.connection_events
  vpc_endpoint_id             = try(each.value.vpc_endpoint_id, null)
  vpc_endpoint_service_id     = try(each.value.vpc_endpoint_service_id, null)
}
