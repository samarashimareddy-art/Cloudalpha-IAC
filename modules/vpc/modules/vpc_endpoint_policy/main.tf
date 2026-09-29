###############################
# aws_vpc_endpoint_policy
###############################
resource "aws_vpc_endpoint_policy" "this" {
  for_each = var.endpoint_policies

  vpc_endpoint_id = each.value["vpc_endpoint_id"]
  policy          = each.value["policy"]
}