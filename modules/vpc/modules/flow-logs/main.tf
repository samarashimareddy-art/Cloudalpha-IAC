resource "aws_cloudwatch_log_group" "flow_logs" {
  count             = var.create_log_group ? 1 : 0
  name              = var.log_group_name
  retention_in_days = var.log_group_retention_days
  tags              = var.tags
}

resource "aws_iam_role" "flow_logs_role" {
  count              = var.create_iam_role ? 1 : 0
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role_policy[0].json
}

data "aws_iam_policy_document" "flow_logs_assume_role_policy" {
  count = var.create_iam_role ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  count  = var.create_iam_role ? 1 : 0
  name   = var.policy_name
  role   = aws_iam_role.flow_logs_role[0].id
  policy = data.aws_iam_policy_document.flow_logs_permissions[0].json
}

data "aws_iam_policy_document" "flow_logs_permissions" {
  count = var.create_iam_role ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_flow_log" "this" {
  traffic_type = var.traffic_type
  
  # Only specify the target that is provided (only one allowed)
  vpc_id                        = var.vpc_id != null ? var.vpc_id : null
  subnet_id                     = var.subnet_id != null && var.vpc_id == null ? var.subnet_id : null
  eni_id                        = var.eni_id != null && var.vpc_id == null && var.subnet_id == null ? var.eni_id : null
  transit_gateway_id            = var.transit_gateway_id != null && var.vpc_id == null && var.subnet_id == null && var.eni_id == null ? var.transit_gateway_id : null
  transit_gateway_attachment_id = var.transit_gateway_attachment_id != null && var.vpc_id == null && var.subnet_id == null && var.eni_id == null && var.transit_gateway_id == null ? var.transit_gateway_attachment_id : null

  log_destination            = var.create_log_group ? aws_cloudwatch_log_group.flow_logs[0].arn : var.log_destination
  log_destination_type       = var.log_destination_type
  log_format                 = var.log_format
  max_aggregation_interval   = var.max_aggregation_interval
  iam_role_arn               = var.create_iam_role ? aws_iam_role.flow_logs_role[0].arn : var.iam_role_arn
  deliver_cross_account_role = var.deliver_cross_account_role

  dynamic "destination_options" {
    for_each = var.destination_options != null ? [1] : []
    content {
      file_format                = var.destination_options.file_format
      hive_compatible_partitions = var.destination_options.hive_compatible_partitions
      per_hour_partition         = var.destination_options.per_hour_partition
    }
  }

  tags = var.tags
}
