data "aws_canonical_user_id" "this" {}

data "aws_caller_identity" "current" {}

#################################################################################################
# Locals
#################################################################################################
locals {
  create_bucket = var.create_bucket
  attach_policy = var.attach_require_latest_tls_policy || var.attach_elb_log_delivery_policy || var.attach_lb_log_delivery_policy || var.attach_deny_insecure_transport_policy || var.attach_inventory_destination_policy || var.attach_policy
}
#################################################################################################
# S3 Bucket
#################################################################################################
resource "aws_s3_bucket" "this" {
  count = local.create_bucket ? 1 : 0

  bucket              = var.bucket
  bucket_prefix       = var.bucket_prefix
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = var.tags
  
  lifecycle {
    precondition {
      condition     = var.bucket != null || var.bucket_prefix != null
      error_message = "Either 'bucket' or 'bucket_prefix' must be specified."
    }
    precondition {
      condition     = !(var.bucket != null && var.bucket_prefix != null)
      error_message = "Provide only one: 'bucket' OR 'bucket_prefix' (not both)."
    }
  }
}
#################################################################################################
# S3 Bucket Logging
#################################################################################################
resource "aws_s3_bucket_logging" "this" {
  count = local.create_bucket && var.logging != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  target_bucket         = var.logging.target_bucket
  target_prefix         = try(var.logging.target_prefix, null)
  expected_bucket_owner = var.expected_bucket_owner
}

#################################################################################################
# S3 Bucket ACL
#################################################################################################
resource "aws_s3_bucket_acl" "this" {
  count = local.create_bucket && ((var.acl != null && var.acl != "null") || length(var.grant) > 0) ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  acl                   = var.acl == "null" ? null : var.acl

  dynamic "access_control_policy" {
    for_each = length(var.grant) > 0 ? [true] : []

    content {
      dynamic "grant" {
        for_each = var.grant

        content {
          permission = grant.value.permission

          grantee {
            type          = grant.value.type
            id            = try(grant.value.id, null)
            uri           = try(grant.value.uri, null)
            email_address = try(grant.value.email, null)
          }
        }
      }

      owner {
        id = try(var.owner.id, data.aws_canonical_user_id.this.id, null)
      }
    }
  }
}
#################################################################################################
# S3 Bucket Website Configuration
#################################################################################################
resource "aws_s3_bucket_website_configuration" "this" {
  count = local.create_bucket && var.website != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "index_document" {
    for_each = try([var.website.index_document], [])

    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = try([var.website.error_document], [])

    content {
      key = error_document.value
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = try([var.website.redirect_all_requests_to], [])

    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }

  dynamic "routing_rule" {
    for_each = try(flatten([var.website.routing_rules]), [])

    content {
      dynamic "condition" {
        for_each = try([routing_rule.value.condition], [])

        content {
          http_error_code_returned_equals = try(condition.value.http_error_code_returned_equals, null)
          key_prefix_equals               = try(condition.value.key_prefix_equals, null)
        }
      }

      redirect {
        host_name               = try(routing_rule.value.redirect.host_name, null)
        http_redirect_code      = try(routing_rule.value.redirect.http_redirect_code, null)
        protocol                = try(routing_rule.value.redirect.protocol, null)
        replace_key_prefix_with = try(routing_rule.value.redirect.replace_key_prefix_with, null)
        replace_key_with        = try(routing_rule.value.redirect.replace_key_with, null)
      }
    }
  }
}

#################################################################################################
# S3 Bucket Versioning
#################################################################################################
resource "aws_s3_bucket_versioning" "this" {
  count = local.create_bucket && var.versioning != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  mfa                   = try(var.versioning.mfa, null)

  versioning_configuration {
    status     = try(var.versioning.enabled ? "Enabled" : "Suspended", tobool(var.versioning.status) ? "Enabled" : "Suspended", title(lower(var.versioning.status)), "Suspended")
    mfa_delete = try(tobool(var.versioning.mfa_delete) ? "Enabled" : "Disabled", title(lower(var.versioning.mfa_delete)), null)
  }
}

#################################################################################################
# S3 Bucket Server-Side Encryption Configuration
#################################################################################################
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = local.create_bucket && var.server_side_encryption_configuration != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = try(flatten([var.server_side_encryption_configuration.rule]), [])

    content {
      bucket_key_enabled = try(rule.value.bucket_key_enabled, null)

      dynamic "apply_server_side_encryption_by_default" {
        for_each = try([rule.value.apply_server_side_encryption_by_default], [])

        content {
          sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
          kms_master_key_id = try(apply_server_side_encryption_by_default.value.kms_master_key_id, null)
        }
      }
    }
  }
}

#################################################################################################
# S3 Bucket Accelerate Configuration
#################################################################################################
resource "aws_s3_bucket_accelerate_configuration" "this" {
  count = local.create_bucket && var.acceleration_status != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  status                = title(lower(var.acceleration_status))
}

#################################################################################################
# S3 Bucket Request Payment Configuration
#################################################################################################
resource "aws_s3_bucket_request_payment_configuration" "this" {
  count = local.create_bucket && var.request_payer != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  payer                 = lower(var.request_payer) == "requester" ? "Requester" : "BucketOwner"
}

#################################################################################################
# S3 Bucket CORS Configuration
#################################################################################################
resource "aws_s3_bucket_cors_configuration" "this" {
  count = local.create_bucket && length(var.cors_rule) > 0 ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "cors_rule" {
    for_each = var.cors_rule

    content {
      id              = try(cors_rule.value.id, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}

#################################################################################################
# S3 Bucket Lifecycle Configuration
#################################################################################################
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = local.create_bucket && length(var.lifecycle_rule) > 0 ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = var.lifecycle_rule

    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.enabled ? "Enabled" : "Disabled", tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)), "Enabled")

      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.abort_incomplete_multipart_upload_days], [])

        content {
          days_after_initiation = try(rule.value.abort_incomplete_multipart_upload_days, null)
        }
      }

      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {}
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(v.tags, v.tag, []))) == 1]

        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(v.tags, v.tag, []))) > 1]

        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

#################################################################################################
# S3 Bucket Object Lock Configuration
#################################################################################################
resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = local.create_bucket && var.object_lock_enabled && try(var.object_lock_configuration.rule.default_retention, null) != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  token                 = try(var.object_lock_configuration.token, null)
  object_lock_enabled   = "Enabled"

  rule {
    default_retention {
      mode  = var.object_lock_configuration.rule.default_retention.mode
      days  = try(var.object_lock_configuration.rule.default_retention.days, null)
      years = try(var.object_lock_configuration.rule.default_retention.years, null)
    }
  }
}

#################################################################################################
# S3 Bucket Replication Configuration
#################################################################################################
resource "aws_s3_bucket_replication_configuration" "this" {
  count = local.create_bucket && var.replication_configuration != null ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  role   = var.replication_configuration.role

  dynamic "rule" {
    for_each = flatten(try([var.replication_configuration.rule], [var.replication_configuration.rules], []))

    content {
      id       = try(rule.value.id, null)
      priority = try(rule.value.priority, null)
      status   = try(tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)), "Enabled")

      dynamic "delete_marker_replication" {
        for_each = flatten(try([rule.value.delete_marker_replication_status], [rule.value.delete_marker_replication], []))

        content {
          status = try(tobool(delete_marker_replication.value) ? "Enabled" : "Disabled", title(lower(delete_marker_replication.value)), "Disabled")
        }
      }

      dynamic "existing_object_replication" {
        for_each = flatten(try([rule.value.existing_object_replication_status], [rule.value.existing_object_replication], []))

        content {
          status = try(tobool(existing_object_replication.value) ? "Enabled" : "Disabled", title(lower(existing_object_replication.value)), "Disabled")
        }
      }

      dynamic "destination" {
        for_each = try(flatten([rule.value.destination]), [])

        content {
          bucket        = destination.value.bucket
          storage_class = try(destination.value.storage_class, null)
          account       = try(destination.value.account_id, destination.value.account, null)
          access_control_translation {
            owner = title(lower(try(destination.value.access_control_translation.owner, "Destination")))
          }
          encryption_configuration {
            replica_kms_key_id = try(destination.value.encryption_configuration.replica_kms_key_id, null)
          }
          replication_time {
            status = try(tobool(destination.value.replication_time.status) ? "Enabled" : "Disabled", title(lower(destination.value.replication_time.status)), "Disabled")
            time {
              minutes = try(destination.value.replication_time.minutes, 15)
            }
          }
          metrics {
            status = try(tobool(destination.value.metrics.status) ? "Enabled" : "Disabled", title(lower(destination.value.metrics.status)), "Disabled")
            event_threshold {
              minutes = try(destination.value.metrics.minutes, 15)
            }
          }
        }
      }

      dynamic "source_selection_criteria" {
        for_each = try(flatten([rule.value.source_selection_criteria]), [])

        content {
          replica_modifications {
            status = try(tobool(source_selection_criteria.value.replica_modifications.enabled) ? "Enabled" : "Disabled", title(lower(source_selection_criteria.value.replica_modifications.status)), "Disabled")
          }
          sse_kms_encrypted_objects {
            status = try(tobool(source_selection_criteria.value.sse_kms_encrypted_objects.enabled) ? "Enabled" : "Disabled", title(lower(source_selection_criteria.value.sse_kms_encrypted_objects.status)), "Disabled")
          }
        }
      }

      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {}
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(v.tags, v.tag, []))) == 1]

        content {
          prefix = try(filter.value.prefix, null)
          tag {
            key   = try(filter.value.tag.key, null)
            value = try(filter.value.tag.value, null)
          }
        }
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(v.tags, v.tag, []))) > 1]

        content {
          and {
            prefix = try(filter.value.prefix, null)
            tags   = try(filter.value.tags, null)
          }
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

#################################################################################################
# S3 Bucket Policy
#################################################################################################
resource "aws_s3_bucket_policy" "this" {
  count = local.create_bucket && local.attach_policy ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.combined[0].json
}

#################################################################################################
# IAM Policy Document
#################################################################################################
data "aws_iam_policy_document" "combined" {
  count = local.create_bucket && local.attach_policy ? 1 : 0

  source_policy_documents = compact([
    var.attach_elb_log_delivery_policy ? data.aws_iam_policy_document.elb_log_delivery[0].json : "",
    var.attach_lb_log_delivery_policy ? data.aws_iam_policy_document.lb_log_delivery[0].json : "",
    var.attach_require_latest_tls_policy ? data.aws_iam_policy_document.require_latest_tls[0].json : "",
    var.attach_deny_insecure_transport_policy ? data.aws_iam_policy_document.deny_insecure_transport[0].json : "",
    var.attach_inventory_destination_policy ? data.aws_iam_policy_document.inventory_destination_policy[0].json : "",
    var.policy != null ? var.policy : ""
  ])
}
#################################################################################################
# ELB Service Account
#################################################################################################
data "aws_elb_service_account" "this" {
  count = local.create_bucket && var.attach_elb_log_delivery_policy ? 1 : 0
}

#################################################################################################
# IAM Policy Document for ELB Log Delivery
#################################################################################################
data "aws_iam_policy_document" "elb_log_delivery" {
  count = local.create_bucket && var.attach_elb_log_delivery_policy ? 1 : 0

  statement {
    sid = "ELBLogDelivery"
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this[0].arn]
    }
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this[0].arn}/*"]
  }
}

#################################################################################################
# IAM Policy Document for LB Log Delivery
#################################################################################################
data "aws_iam_policy_document" "lb_log_delivery" {
  count = local.create_bucket && var.attach_lb_log_delivery_policy ? 1 : 0

  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this[0].arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.this[0].arn]
  }
}

#################################################################################################
# IAM Policy Document for Deny Insecure Transport
#################################################################################################
data "aws_iam_policy_document" "deny_insecure_transport" {
  count = local.create_bucket && var.attach_deny_insecure_transport_policy ? 1 : 0

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

#################################################################################################
# IAM Policy Document for Require Latest TLS
#################################################################################################
data "aws_iam_policy_document" "require_latest_tls" {
  count = local.create_bucket && var.attach_require_latest_tls_policy ? 1 : 0

  statement {
    sid    = "DenyOutdatedTLS"
    effect = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values   = ["1.2"]
    }
  }
}

#################################################################################################
# S3 Bucket Public Access Block
#################################################################################################
resource "aws_s3_bucket_public_access_block" "this" {
  count = local.create_bucket && var.attach_public_policy ? 1 : 0

  bucket = local.attach_policy ? aws_s3_bucket_policy.this[0].id : aws_s3_bucket.this[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  depends_on = [aws_s3_bucket_policy.this]
}

#################################################################################################
# S3 Bucket Ownership Controls
#################################################################################################
resource "aws_s3_bucket_ownership_controls" "this" {
  count = local.create_bucket && var.control_object_ownership ? 1 : 0

  bucket = local.attach_policy ? aws_s3_bucket_policy.this[0].id : aws_s3_bucket.this[0].id

  rule {
    object_ownership = var.object_ownership
  }

  depends_on = [
    aws_s3_bucket_policy.this,
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket.this
  ]
}

#################################################################################################
# S3 Bucket Intelligent Tiering Configuration
#################################################################################################
resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count = local.create_bucket && var.intelligent_tiering != null ? 1 : 0

  name   = try(var.intelligent_tiering.name, "intelligent-tiering")
  bucket = aws_s3_bucket.this[0].id
  status = try(tobool(var.intelligent_tiering.status) ? "Enabled" : "Disabled", title(lower(var.intelligent_tiering.status)), "Enabled")

  dynamic "filter" {
    for_each = length(try(flatten([var.intelligent_tiering.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(var.intelligent_tiering.filter.prefix, null)
      tags   = try(var.intelligent_tiering.filter.tags, null)
    }
  }

  dynamic "tiering" {
    for_each = var.intelligent_tiering.tiering

    content {
      access_tier = tiering.key
      days        = tiering.value.days
    }
  }
}

#################################################################################################
# S3 Bucket Metric
#################################################################################################
resource "aws_s3_bucket_metric" "this" {
  count = local.create_bucket && var.metric_configuration != null ? 1 : 0

  name   = var.metric_configuration.name
  bucket = aws_s3_bucket.this[0].id

  dynamic "filter" {
    for_each = length(try(flatten([var.metric_configuration.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(var.metric_configuration.filter.prefix, null)
      tags   = try(var.metric_configuration.filter.tags, null)
    }
  }
}

#################################################################################################
# S3 Bucket Inventory
#################################################################################################
resource "aws_s3_bucket_inventory" "this" {
  count = local.create_bucket && var.inventory_configuration != null ? 1 : 0

  name                     = try(var.inventory_configuration.name, "inventory")
  bucket                   = aws_s3_bucket.this[0].id
  included_object_versions = var.inventory_configuration.included_object_versions
  enabled                  = try(var.inventory_configuration.enabled, true)
  optional_fields          = try(var.inventory_configuration.optional_fields, null)

  destination {
    bucket {
      bucket_arn = try(var.inventory_configuration.destination.bucket_arn, aws_s3_bucket.this[0].arn)
      format     = try(var.inventory_configuration.destination.format, null)
      account_id = try(var.inventory_configuration.destination.account_id, null)
      prefix     = try(var.inventory_configuration.destination.prefix, null)

      dynamic "encryption" {
        for_each = length(try(flatten([var.inventory_configuration.destination.encryption]), [])) == 0 ? [] : [true]

        content {
          dynamic "sse_kms" {
            for_each = try(var.inventory_configuration.destination.encryption.encryption_type, null) == "sse_kms" ? [true] : []

            content {
              key_id = try(var.inventory_configuration.destination.encryption.kms_key_id, null)
            }
          }

          dynamic "sse_s3" {
            for_each = try(var.inventory_configuration.destination.encryption.encryption_type, null) == "sse_s3" ? [true] : []

            content {}
          }
        }
      }
    }
  }

  schedule {
    frequency = var.inventory_configuration.frequency
  }

  dynamic "filter" {
    for_each = length(try(flatten([var.inventory_configuration.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(var.inventory_configuration.filter.prefix, null)
    }
  }
}

#################################################################################################
# IAM Policy Document for Inventory Destination Policy
#################################################################################################
data "aws_iam_policy_document" "inventory_destination_policy" {
  count = local.create_bucket && var.attach_inventory_destination_policy ? 1 : 0

  statement {
    sid    = "DestinationInventoryPolicy"
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this[0].arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [try(var.inventory_self_source_destination ? aws_s3_bucket.this[0].arn : var.inventory_source_bucket_arn, aws_s3_bucket.this[0].arn)]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [try(var.inventory_self_source_destination ? data.aws_caller_identity.current.account_id : var.inventory_source_account_id, data.aws_caller_identity.current.account_id)]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

#################################################################################################
# S3 Bucket Analytics Configuration
#################################################################################################
resource "aws_s3_bucket_analytics_configuration" "this" {
  count = local.create_bucket && var.analytics_configuration != null ? 1 : 0

  name   = try(var.analytics_configuration.name, "analytics")
  bucket = aws_s3_bucket.this[0].id

  dynamic "filter" {
    for_each = length(try(flatten([var.analytics_configuration.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(var.analytics_configuration.filter.prefix, null)
      tags   = try(var.analytics_configuration.filter.tags, null)
    }
  }

  storage_class_analysis {
  data_export {
    destination {
      s3_bucket_destination {
        bucket_arn        = var.analytics_configuration.storage_class_analysis.data_export.destination.s3_bucket_destination.bucket_arn
        format            = try(var.analytics_configuration.storage_class_analysis.data_export.destination.s3_bucket_destination.format, "CSV")
        bucket_account_id = try(var.analytics_configuration.storage_class_analysis.data_export.destination.s3_bucket_destination.bucket_account_id, null)
        prefix            = try(var.analytics_configuration.storage_class_analysis.data_export.destination.s3_bucket_destination.prefix, null)
      }
      }
    }
  }
}

#################################################################################################
# S3 Bucket Notification
#################################################################################################
resource "aws_s3_bucket_notification" "this" {
  count = local.create_bucket && var.bucket_notifications != null ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  dynamic "queue" {
    for_each = try(var.bucket_notifications.queue, [])

    content {
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = try(queue.value.filter_prefix, null)
      filter_suffix = try(queue.value.filter_suffix, null)
      id            = try(queue.value.id, null)
    }
  }

  dynamic "topic" {
    for_each = try(var.bucket_notifications.topic, [])

    content {
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = try(topic.value.filter_prefix, null)
      filter_suffix = try(topic.value.filter_suffix, null)
      id            = try(topic.value.id, null)
    }
  }

  dynamic "lambda_function" {
    for_each = try(var.bucket_notifications.lambda_function, [])

    content {
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = try(lambda_function.value.filter_prefix, null)
      filter_suffix       = try(lambda_function.value.filter_suffix, null)
      id                  = try(lambda_function.value.id, null)
    }
  }

  eventbridge = try(var.bucket_notifications.eventbridge, false)
}

#################################################################################################
# S3 Object
#################################################################################################
resource "aws_s3_object" "this" {
  for_each = local.create_bucket ? { for idx, obj in var.objects : idx => obj } : {}

  bucket                 = aws_s3_bucket.this[0].id
  key                    = each.value.key
  source                 = try(each.value.source, null)
  content                = try(each.value.content, null)
  content_type           = try(each.value.content_type, null)
  acl                    = try(each.value.acl, null)
  cache_control          = try(each.value.cache_control, null)
  content_disposition    = try(each.value.content_disposition, null)
  content_encoding       = try(each.value.content_encoding, null)
  content_language       = try(each.value.content_language, null)
  storage_class          = try(each.value.storage_class, null)
  etag                   = try(each.value.etag, null)
  metadata               = try(each.value.metadata, {})
  server_side_encryption = try(each.value.server_side_encryption, null)
  kms_key_id             = try(each.value.kms_key_id, null)
  bucket_key_enabled     = try(each.value.bucket_key_enabled, null)
  tags                   = merge(var.tags, try(each.value.tags, {}))
  force_destroy          = try(each.value.force_destroy, false)
  object_lock_legal_hold_status = try(each.value.object_lock_legal_hold_status, null)
  object_lock_mode             = try(each.value.object_lock_mode, null)
  object_lock_retain_until_date = try(each.value.object_lock_retain_until_date, null)
}
#################################################################################################
# S3 Object Copy
#################################################################################################
resource "aws_s3_object_copy" "this" {
  for_each = local.create_bucket ? { for idx, obj in var.object_copies : idx => obj } : {}

  bucket                 = aws_s3_bucket.this[0].id
  key                    = each.value.key
  source                 = each.value.source
  acl                    = try(each.value.acl, null)
  cache_control          = try(each.value.cache_control, null)
  content_disposition    = try(each.value.content_disposition, null)
  content_encoding       = try(each.value.content_encoding, null)
  content_language       = try(each.value.content_language, null)
  content_type           = try(each.value.content_type, null)
  copy_if_match          = try(each.value.copy_if_match, null)
  copy_if_modified_since = try(each.value.copy_if_modified_since, null)
  copy_if_none_match     = try(each.value.copy_if_none_match, null)
  copy_if_unmodified_since = try(each.value.copy_if_unmodified_since, null)
  metadata               = try(each.value.metadata, {})
  metadata_directive     = try(each.value.metadata_directive, null)
  server_side_encryption = try(each.value.server_side_encryption, null)
  kms_key_id             = try(each.value.kms_key_id, null)
  storage_class          = try(each.value.storage_class, null)
  tagging_directive      = try(each.value.tagging_directive, null)
  tags                   = merge(var.tags, try(each.value.tags, {}))
  object_lock_legal_hold_status = try(each.value.object_lock_legal_hold_status, null)
  object_lock_mode             = try(each.value.object_lock_mode, null)
  object_lock_retain_until_date = try(each.value.object_lock_retain_until_date, null)
}