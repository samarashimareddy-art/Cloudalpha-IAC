###############################
# aws_vpc_endpoint_route_table_association
###############################
resource "aws_vpc_endpoint_route_table_association" "this" {
  for_each = var.route_table_associations

  vpc_endpoint_id = each.value["vpc_endpoint_id"]
  route_table_id  = each.value["route_table_id"]
}

###############################
# aws_vpc_endpoint_security_group_association
###############################
resource "aws_vpc_endpoint_security_group_association" "this" {
  for_each = var.sg_associations

  vpc_endpoint_id             = each.value.vpc_endpoint_id
  security_group_id           = each.value.security_group_id
  replace_default_association = try(each.value.replace_default_association, false)
}

###############################
# aws_vpc_endpoint_subnet_association
###############################
resource "aws_vpc_endpoint_subnet_association" "this" {
  for_each = var.subnet_associations

  vpc_endpoint_id = each.value["vpc_endpoint_id"]
  subnet_id       = each.value["subnet_id"]
}