resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.combined.json
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = compact([
    var.policy_json_file != null ? file(var.policy_json_file) : null,
    var.policy_json_string != null ? var.policy_json_string : null,
    var.enable_elb_log_delivery ? data.aws_iam_policy_document.elb_log_delivery[0].json : null,
    var.enable_lb_log_delivery ? data.aws_iam_policy_document.lb_log_delivery[0].json : null,
    var.enable_deny_insecure_transport ? data.aws_iam_policy_document.deny_insecure_transport[0].json : null,
    var.enable_require_latest_tls ? data.aws_iam_policy_document.require_latest_tls[0].json : null,
    var.enable_inventory_destination ? data.aws_iam_policy_document.inventory_destination[0].json : null
  ])
}

# ELB Log Delivery Policy
data "aws_elb_service_account" "this" {
  count = var.enable_elb_log_delivery ? 1 : 0
}

data "aws_iam_policy_document" "elb_log_delivery" {
  count = var.enable_elb_log_delivery ? 1 : 0

  statement {
    sid = "ELBLogDelivery"
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this[0].arn]
    }
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
}

# LB Log Delivery Policy
data "aws_iam_policy_document" "lb_log_delivery" {
  count = var.enable_lb_log_delivery ? 1 : 0

  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
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
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }
}

# Deny Insecure Transport Policy
data "aws_iam_policy_document" "deny_insecure_transport" {
  count = var.enable_deny_insecure_transport ? 1 : 0

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
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

# Require Latest TLS Policy
data "aws_iam_policy_document" "require_latest_tls" {
  count = var.enable_require_latest_tls ? 1 : 0

  statement {
    sid    = "DenyOutdatedTLS"
    effect = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
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

# Inventory Destination Policy
data "aws_iam_policy_document" "inventory_destination" {
  count = var.enable_inventory_destination ? 1 : 0

  statement {
    sid = "InventoryDestination"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid = "InventoryDestinationBucketCheck"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }
}