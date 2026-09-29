<!-- markdownlint-disable -->

# terraform-aws-s3-bucket
<!-- markdownlint-restore -->

## Introduction

Amazon Simple Storage Service (Amazon S3) is a highly scalable, durable, and secure object storage service from AWS. It provides industry-leading performance for storing and retrieving any amount of data, such as application assets, backups, logs, and machine learning datasets. S3 supports features like versioning, lifecycle policies, server-side encryption, event notifications, and storage analytics to meet diverse storage and compliance requirements.

## Usage

S3 buckets store objects in a flat structure, accessible via unique keys, and can be configured for static website hosting, logging, replication, and intelligent tiering. S3 integrates with AWS services like Lambda, SNS, SQS, ELB, and CloudTrail for event-driven workflows and logging. It supports directory buckets for hierarchical storage and policies to enforce secure transport, require the latest TLS, and control public access.

Common use cases include:
- **Data Storage**: Store application data, backups, or archives.
- **Static Website Hosting**: Host websites with HTML, CSS, and JavaScript.
- **Event Notifications**: Trigger Lambda, SNS, or SQS on object events.
- **Logging and Analytics**: Store logs for ELB/ALB or enable storage analytics.
- **Data Lakes**: Centralize datasets with directory buckets for analytics.
- **Cross-Region Replication**: Replicate data for disaster recovery or compliance.
- **Cost Optimization**: Use lifecycle policies and intelligent tiering to reduce costs.

For more details, see the [Amazon S3 Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html).

This Terraform module simplifies creating and managing S3 buckets with configurations for:
- Single bucket creation with dynamic naming and tagging
- Access control lists (ACLs), ownership controls, and public access blocks
- Versioning, server-side encryption, and object lock
- Lifecycle policies, intelligent tiering, and storage analytics
- CORS, website hosting, logging, and event notifications (Lambda, SNS, SQS)
- Replication, inventory, and directory buckets
- Object management (upload, copy) and bucket policies for ELB/ALB logs, TLS enforcement, and inventory

> [!TIP]
> #### 👽 Use Atmos with Terraform
> Cloud Posse uses [`atmos`](https://atmos.tools) to easily orchestrate multiple environments using Terraform. <br/>
> Works with [Github Actions](https://atmos.tools/integrations/github-actions/), [Atlantis](https://atmos.tools/integrations/atlantis), or [Spacelift](https://atmos.tools/integrations/spacelift).
>
> <details>
> <summary><strong>Watch demo of using Atmos with Terraform</strong></summary>
> <img src="https://github.com/cloudposse/atmos/blob/main/docs/demo.gif?raw=true"/><br/>
> <i>Example of running <a href="https://atmos.tools"><code>atmos</code></a> to manage infrastructure from our <a href="https://atmos.tools/quick-start/">Quick Start</a> tutorial.</i>
> </details>

> [!IMPORTANT]
> In Cloud Posse's examples, we avoid pinning modules to specific versions to prevent discrepancies between the documentation and the latest released versions. However, for your own projects, we strongly advise pinning each module to the exact version you're using. This practice ensures the stability of your infrastructure. Additionally, we recommend implementing a systematic approach for updating versions to avoid unexpected changes.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.38.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.38.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| None | | |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_accelerate_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_analytics_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_analytics_configuration) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_request_payment_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_directory_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_directory_bucket) | resource |
| [aws_s3_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object_copy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object_copy) | resource |
| [aws_canonical_user_id.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny_insecure_transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elb_log_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.inventory_destination_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lb_log_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.require_latest_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | Default canned ACL for buckets (e.g., `private`, `public-read`). | `string` | `null` | no |
| analytics_configuration | Storage class analytics configurations for buckets. | `map(any)` | `{}` | no |
| attach_deny_insecure_transport_policy | Attach policy to deny non-secure transport (HTTP). | `bool` | `false` | no |
| attach_elb_log_delivery_policy | Attach policy for ELB log delivery. | `bool` | `false` | no |
| attach_inventory_destination_policy | Attach policy for S3 inventory destination. | `bool` | `false` | no |
| attach_lb_log_delivery_policy | Attach policy for ALB/NLB log delivery. | `bool` | `false` | no |
| attach_policy | Attach a custom bucket policy. | `bool` | `false` | no |
| attach_public_policy | Enable public access block configuration. | `bool` | `true` | no |
| attach_require_latest_tls_policy | Attach policy to require TLS 1.2 or higher. | `bool` | `false` | no |
| bucket_notifications | Notification configurations (Lambda, SNS, SQS) for buckets. | `map(any)` | `{}` | no |
| bucket_objects | Deprecated: Objects to upload to buckets (use `objects` instead). | `map(any)` | `{}` | no |
| buckets | Map of bucket configurations (name, versioning, etc.). | `map(any)` | `{}` | no |
| cors_rule | CORS rules for buckets. | `list(any)` | `[]` | no |
| create_bucket | Create S3 buckets if true. | `bool` | `true` | no |
| directory_buckets | Map of directory bucket configurations. | `map(any)` | `{}` | no |
| expected_bucket_owner | Expected AWS account ID of the bucket owner. | `string` | `null` | no |
| force_destroy | Allow bucket deletion even if it contains objects. | `bool` | `false` | no |
| grant | List of ACL grant configurations. | `list(any)` | `[]` | no |
| intelligent_tiering | Intelligent tiering configurations for buckets. | `map(any)` | `{}` | no |
| inventory_configuration | Inventory configurations for buckets. | `map(any)` | `{}` | no |
| inventory_self_source_destination | Use the same bucket as inventory source and destination. | `bool` | `false` | no |
| inventory_source_account_id | Account ID for inventory source bucket. | `string` | `null` | no |
| inventory_source_bucket_arn | ARN of the inventory source bucket. | `string` | `null` | no |
| lifecycle_rule | Lifecycle rules for buckets. | `list(any)` | `[]` | no |
| metric_configuration | Metric configurations for buckets. | `map(any)` | `{}` | no |
| object_copies | Objects to copy within or across buckets. | `map(any)` | `{}` | no |
| object_lock_enabled | Enable object lock for buckets. | `bool` | `false` | no |
| objects | Objects to upload to buckets. | `map(any)` | `{}` | no |
| owner | Bucket owner configuration (id, display_name). | `map(string)` | `{}` | no |
| policy | Custom bucket policy (JSON). | `string` | `""` | no |
| tags | Additional tags (e.g., `{"Environment": "prod"}`). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_arns | Map of ARNs for created S3 buckets. |
| bucket_ids | Map of IDs (names) for created S3 buckets. |
| bucket_domain_names | Map of domain names for created S3 buckets. |

## Usage Examples

### S3 Bucket with Encryption and Versioning

Creates an S3 bucket with server-side encryption and versioning.

```hcl
module "s3_bucket" {
  source = "./modules/s3"

  create_bucket = true
  bucket        = "my-app-data-bucket"
  
  versioning = {
    enabled = true
  }
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

### S3 Bucket for Static Website with CORS and Notifications

Sets up an S3 bucket for website hosting with CORS and Lambda notifications.

```hcl
module "s3_bucket" {
  source = "./modules/s3"

  create_bucket = true
  bucket        = "my-website-bucket"
  
  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
  
  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["https://example.com"]
      max_age_seconds = 3000
    }
  ]
  
  bucket_notifications = {
    lambda_function = [
      {
        lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
        events              = ["s3:ObjectCreated:*"]
        filter_prefix       = "uploads/"
      }
    ]
  }
  
  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
```

### S3 Bucket for ELB Logs with Lifecycle and Analytics

Creates a bucket for ELB logs with lifecycle rules and storage analytics.

```hcl
module "s3_bucket" {
  source = "./modules/s3"

  create_bucket                  = true
  bucket                         = "my-elb-logs-bucket"
  attach_elb_log_delivery_policy = true
  
  lifecycle_rule = [
    {
      id      = "log-transition"
      enabled = true
      transition = [
        {
          days          = 30
          storage_class = "GLACIER"
        }
      ]
    }
  ]
  
  analytics_configuration = {
    name = "logs-analytics"
    storage_class_analysis = {
      data_export = {
        destination = {
          s3_bucket_destination = {
            bucket_arn = "arn:aws:s3:::analytics-destination-bucket"
            format     = "CSV"
          }
        }
      }
    }
  }
  
  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
```

### S3 Bucket with Object Upload

Creates a bucket and uploads objects.

```hcl
module "s3_bucket" {
  source = "./modules/s3"

  create_bucket = true
  bucket        = "my-data-bucket"
  
  objects = [
    {
      key          = "config.json"
      content      = "{\"setting\": \"value\"}"
      content_type = "application/json"
    }
  ]
  
  tags = {
    Environment = "staging"
    Terraform   = "true"
  }
}
```

## Features

- **Security**: Server-side encryption, TLS enforcement, and public access blocks
- **Access Control**: ACLs, ownership controls, and policies for ELB/ALB logs
- **Cost Optimization**: Lifecycle policies, intelligent tiering, and analytics
- **Website Hosting**: Configure buckets for static websites with CORS support
- **Event Notifications**: Trigger Lambda, SNS, or SQS on object events
- **Replication**: Cross-region or same-region replication for high availability
- **Object Management**: Upload and copy objects with metadata and encryption

## Notes

- **Single Bucket**: This module creates one S3 bucket per invocation. To create multiple buckets, invoke the module multiple times
- **Notifications**: Ensure Lambda, SNS, or SQS ARNs are valid and have necessary permissions
- **Analytics**: Requires a destination bucket ARN for storage class analysis exports
- **Object Upload**: Use `objects` list to upload multiple objects to the bucket
- **Dependencies**: Ensure aws_s3_bucket_policy and public_access_block are applied in correct order to avoid conflicts

Troubleshooting

Bucket Creation Errors: Verify bucket names are globally unique and follow S3 naming rules.
Policy Conflicts: Check attach_policy and related flags (attach_elb_log_delivery_policy, etc.) for consistency

Related Projects

terraform-null-label - Generate consistent names and tags for resources.
terraform-aws-s3-log-storage - Create S3 buckets optimized for logging.
terraform-aws-kms - Manage KMS keys for S3 encryption.
terraform-aws-lambda - Deploy Lambda functions for S3 notifications.

References

Amazon S3 User Guide - Official documentation for Amazon S3.
S3 Bucket Policies - Examples of S3 bucket policies.

```
