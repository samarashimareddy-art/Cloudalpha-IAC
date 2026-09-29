variable "traffic_type" {
  description = "Type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the flow log."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the flow log."
  type        = string
  default     = null
}

variable "eni_id" {
  description = "The ID of the Elastic Network Interface to associate with the flow log."
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway to associate with the flow log."
  type        = string
  default     = null
}

variable "transit_gateway_attachment_id" {
  description = "The ID of the Transit Gateway Attachment to associate with the flow log."
  type        = string
  default     = null
}

variable "create_iam_role" {
  description = "Whether to create an IAM role for flow logs"
  type        = bool
  default     = true
}

variable "create_log_group" {
  description = "Whether to create a CloudWatch Log Group for flow logs"
  type        = bool
  default     = true
}

variable "log_group_name" {
  description = "Name of the CloudWatch Log Group for flow logs"
  type        = string
  default     = "/aws/vpc/flowlogs"
}

variable "log_group_retention_days" {
  description = "Retention period for CloudWatch Log Group in days"
  type        = number
  default     = 14
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role for CloudWatch or Firehose."
  type        = string
  default     = null
}

variable "deliver_cross_account_role" {
  description = "ARN of the IAM role for cross-account log delivery."
  type        = string
  default     = null
}

variable "log_destination" {
  description = "The ARN of the logging destination (CloudWatch Log Group, S3 bucket, or Firehose)."
  type        = string
}

variable "log_destination_type" {
  description = "The type of the logging destination: cloud-watch-logs, s3, kinesis-data-firehose."
  type        = string
}

variable "log_format" {
  description = "Fields to include in the flow log record."
  type        = string
}

variable "max_aggregation_interval" {
  description = "Maximum interval for aggregation: 60 or 600."
  type        = number
}

variable "destination_options" {
  description = "Options for the flow log destination."
  type = object({
    file_format                = optional(string, "plain-text")
    hive_compatible_partitions = optional(bool, false)
    per_hour_partition         = optional(bool, false)
  })
}

variable "role_name" {
  description = "Name of the IAM role for VPC Flow Logs"
  type        = string
}

variable "policy_name" {
  description = "Name of the inline policy for VPC Flow Logs"
  type        = string
}

variable "tags" {
  description = "Key-value tags for the flow log."
  type        = map(string)
}
