#####################################################################################################
# S3 Bucket
#####################################################################################################

output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = try(aws_s3_bucket_policy.this[0].id, aws_s3_bucket.this[0].id, "")
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(aws_s3_bucket.this[0].arn, "")
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, "")
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = try(aws_s3_bucket.this[0].bucket_regional_domain_name, "")
}

output "s3_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = try(aws_s3_bucket.this[0].hosted_zone_id, "")
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = try(aws_s3_bucket.this[0].region, "")
}

######################################################################################################
# S3 Bucket Website Configuration
######################################################################################################

output "s3_bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = try(aws_s3_bucket_website_configuration.this[0].website_endpoint, "")
}

output "s3_bucket_website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
  value       = try(aws_s3_bucket_website_configuration.this[0].website_domain, "")
}

######################################################################################################
# S3 Bucket Policy
######################################################################################################

output "s3_bucket_policy" {
  description = "The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string."
  value       = try(aws_s3_bucket_policy.this[0].policy, "")
}

######################################################################################################
# S3 Bucket Logging
######################################################################################################

output "s3_bucket_logging_target_bucket" {
  description = "The target bucket for logging, if logging is configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_logging.this[0].target_bucket, "")
}

######################################################################################################
# S3 Bucket Versioning
######################################################################################################

output "s3_bucket_versioning_status" {
  description = "The versioning status of the bucket, if versioning is configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_versioning.this[0].versioning_configuration[0].status, "")
}

######################################################################################################
# S3 Bucket Server-Side Encryption
######################################################################################################

output "s3_bucket_server_side_encryption_algorithm" {
  description = "The server-side encryption algorithm, if encryption is configured. If not, this will be an empty string."
  value       = try(one(aws_s3_bucket_server_side_encryption_configuration.this[0].rule).apply_server_side_encryption_by_default[0].sse_algorithm, "")
}

######################################################################################################
# S3 Bucket Accelerate Configuration
######################################################################################################

output "s3_bucket_accelerate_status" {
  description = "The accelerate configuration status of the bucket, if configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_accelerate_configuration.this[0].status, "")
}

######################################################################################################
# S3 Bucket CORS Configuration
######################################################################################################

output "s3_bucket_cors_rules" {
  description = "The CORS rules of the bucket, if CORS is configured. If not, this will be an empty list."
  value       = try([for rule in aws_s3_bucket_cors_configuration.this[0].cors_rule : {
    id              = try(rule.id, null)
    allowed_methods = rule.allowed_methods
    allowed_origins = rule.allowed_origins
  }], [])
}

######################################################################################################
# S3 Bucket Lifecycle Configuration
######################################################################################################

output "s3_bucket_lifecycle_rules" {
  description = "The lifecycle rules of the bucket, if lifecycle configuration is set. If not, this will be an empty list."
  value       = try([for rule in tolist(aws_s3_bucket_lifecycle_configuration.this[0].rule) : {
    id     = rule.id
    status = rule.status
  }], [])
}

######################################################################################################
# S3 Bucket Object Lock Configuration
######################################################################################################

output "s3_bucket_object_lock_mode" {
  description = "The object lock retention mode, if object lock is configured. If not, this will be an empty string."
  value       = try(one(aws_s3_bucket_object_lock_configuration.this[0].rule).default_retention[0].mode, "")
}

######################################################################################################
# S3 Bucket Replication Configuration
######################################################################################################

output "s3_bucket_replication_role" {
  description = "The IAM role used for replication, if replication is configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_replication_configuration.this[0].role, "")
}

######################################################################################################
# S3 Bucket Public Access Block
######################################################################################################

output "s3_bucket_public_access_block" {
  description = "The public access block settings, if configured. If not, this will be an empty map."
  value       = try({
    block_public_acls       = aws_s3_bucket_public_access_block.this[0].block_public_acls
    block_public_policy     = aws_s3_bucket_public_access_block.this[0].block_public_policy
    ignore_public_acls      = aws_s3_bucket_public_access_block.this[0].ignore_public_acls
    restrict_public_buckets = aws_s3_bucket_public_access_block.this[0].restrict_public_buckets
  }, {})
}

######################################################################################################
# S3 Bucket Ownership Controls
######################################################################################################

output "s3_bucket_ownership_controls" {
  description = "The object ownership setting, if ownership controls are configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_ownership_controls.this[0].rule[0].object_ownership, "")
}

######################################################################################################
# S3 Bucket Intelligent Tiering Configuration
######################################################################################################

output "s3_bucket_intelligent_tiering_status" {
  description = "The status of intelligent tiering, if configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_intelligent_tiering_configuration.this[0].status, "")
}

######################################################################################################
# S3 Bucket Metrics
######################################################################################################

output "s3_bucket_metrics_name" {
  description = "The name of the bucket metric, if metrics are configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_metric.this[0].name, "")
}

######################################################################################################
# S3 Bucket Inventory
######################################################################################################

output "s3_bucket_inventory_name" {
  description = "The name of the bucket inventory, if inventory is configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_inventory.this[0].name, "")
}

######################################################################################################
# S3 Bucket Analytics Configuration
######################################################################################################

output "s3_bucket_analytics_name" {
  description = "The name of the bucket analytics configuration, if configured. If not, this will be an empty string."
  value       = try(aws_s3_bucket_analytics_configuration.this[0].name, "")
}

######################################################################################################
# S3 Bucket Notification
######################################################################################################

output "s3_bucket_notification_eventbridge" {
  description = "Whether EventBridge notifications are enabled, if notifications are configured. If not, this will be false."
  value       = try(aws_s3_bucket_notification.this[0].eventbridge, false)
}

######################################################################################################
# S3 Bucket Object (Deprecated)
######################################################################################################

output "s3_object_keys" {
  description = "List of keys for S3 objects created."
  value       = [for obj in aws_s3_object.this : obj.key]
}

######################################################################################################
# S3 Object Copy
######################################################################################################

output "s3_object_copy_keys" {
  description = "List of keys for S3 object copies created."
  value       = [for obj in aws_s3_object_copy.this : obj.key]
}

#################################################################################################
# Debug Output for Policy JSON
#################################################################################################
output "bucket_policy_json" {
  description = "The JSON policy document for the bucket."
  value       = try(data.aws_iam_policy_document.combined[0].json, "")
}