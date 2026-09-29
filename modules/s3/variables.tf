variable "create_bucket" {
  description = "Controls if S3 bucket resources should be created."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "bucket" {
  description = "Name of the S3 bucket to create."
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name."
  type        = string
  default     = null
}

variable "logging" {
  description = "Logging configuration for the bucket."
  type = object({
    target_bucket = string
    target_prefix = optional(string)
  })
  default = null
}

variable "website" {
  description = "Website configuration for the bucket."
  type = object({
    index_document = optional(string)
    error_document = optional(string)
    redirect_all_requests_to = optional(object({
      host_name = string
      protocol  = optional(string)
    }))
    routing_rules = optional(list(object({
      condition = optional(object({
        http_error_code_returned_equals = optional(string)
        key_prefix_equals               = optional(string)
      }))
      redirect = object({
        host_name               = optional(string)
        http_redirect_code      = optional(string)
        protocol                = optional(string)
        replace_key_prefix_with = optional(string)
        replace_key_with        = optional(string)
      })
    })))
  })
  default = null
}

variable "versioning" {
  description = "Versioning configuration for the bucket."
  type = object({
    enabled    = optional(bool)
    status     = optional(string)
    mfa        = optional(string)
    mfa_delete = optional(string)
  })
  default = null
}

variable "server_side_encryption_configuration" {
  description = "Server-side encryption configuration for the bucket."
  type = object({
    rule = object({
      bucket_key_enabled = optional(bool)
      apply_server_side_encryption_by_default = object({
        sse_algorithm     = string
        kms_master_key_id = optional(string)
      })
    })
  })
  default = null
}

variable "acceleration_status" {
  description = "Transfer acceleration status (Enabled or Suspended)."
  type        = string
  default     = null
}

variable "request_payer" {
  description = "Request payer configuration (BucketOwner or Requester)."
  type        = string
  default     = null
}

variable "replication_configuration" {
  description = "Replication configuration for the bucket."
  type = object({
    role  = string
    rule  = optional(list(object({
      id       = optional(string)
      priority = optional(number)
      status   = optional(string)
      delete_marker_replication_status = optional(string)
      delete_marker_replication        = optional(string)
      existing_object_replication_status = optional(string)
      existing_object_replication        = optional(string)
      destination = object({
        bucket        = string
        storage_class = optional(string)
        account_id    = optional(string)
        account       = optional(string)
        access_control_translation = optional(object({
          owner = optional(string)
        }))
        encryption_configuration = optional(object({
          replica_kms_key_id = optional(string)
        }))
        replication_time = optional(object({
          status  = optional(string)
          minutes = optional(number)
        }))
        metrics = optional(object({
          status  = optional(string)
          minutes = optional(number)
        }))
      })
      source_selection_criteria = optional(object({
        replica_modifications = optional(object({
          enabled = optional(bool)
          status  = optional(string)
        }))
        sse_kms_encrypted_objects = optional(object({
          enabled = optional(bool)
          status  = optional(string)
        }))
      }))
      filter = optional(object({
        prefix = optional(string)
        tag = optional(object({
          key   = optional(string)
          value = optional(string)
        }))
        tags = optional(map(string))
      }))
    })))
    rules = optional(list(object({
      id       = optional(string)
      priority = optional(number)
      status   = optional(string)
      delete_marker_replication_status = optional(string)
      delete_marker_replication        = optional(string)
      existing_object_replication_status = optional(string)
      existing_object_replication        = optional(string)
      destination = object({
        bucket        = string
        storage_class = optional(string)
        account_id    = optional(string)
        account       = optional(string)
        access_control_translation = optional(object({
          owner = optional(string)
        }))
        encryption_configuration = optional(object({
          replica_kms_key_id = optional(string)
        }))
        replication_time = optional(object({
          status  = optional(string)
          minutes = optional(number)
        }))
        metrics = optional(object({
          status  = optional(string)
          minutes = optional(number)
        }))
      })
      source_selection_criteria = optional(object({
        replica_modifications = optional(object({
          enabled = optional(bool)
          status  = optional(string)
        }))
        sse_kms_encrypted_objects = optional(object({
          enabled = optional(bool)
          status  = optional(string)
        }))
      }))
      filter = optional(object({
        prefix = optional(string)
        tag = optional(object({
          key   = optional(string)
          value = optional(string)
        }))
        tags = optional(map(string))
      }))
    })))
  })
  default = null
}

variable "object_lock_configuration" {
  description = "Object lock configuration for the bucket."
  type = object({
    token = optional(string)
    rule = object({
      default_retention = object({
        mode  = string
        days  = optional(number)
        years = optional(number)
      })
    })
  })
  default = null
}

variable "block_public_acls" {
  description = "Block public ACLs."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies."
  type        = bool
  default     = true
}

variable "control_object_ownership" {
  description = "Enable object ownership controls."
  type        = bool
  default     = false
}

variable "object_ownership" {
  description = "Object ownership setting."
  type        = string
  default     = "ObjectWriter"
}

variable "grant" {
  description = "List of ACL policy grants. Conflicts with `acl` in bucket configuration."
  type        = list(object({
    permission = string
    type       = string
    id         = optional(string)
    uri        = optional(string)
    email      = optional(string)
  }))
  default     = []
}

variable "owner" {
  description = "Bucket owner's ID. Conflicts with `acl` in bucket configuration."
  type        = map(string)
  default     = {}
}

# variable "cors_rule" {
#   description = "Map of CORS rules for Cross-Origin Resource Sharing."
#   type        = map(any)
#   default     = {}
# }
variable "cors_rule" {
  description = "List of CORS rules for the S3 bucket"
  type = list(object({
    allowed_headers = optional(list(string), [])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number)
  }))
  default = []
}


# variable "lifecycle_rule" {
#   description = "Map of object lifecycle management configurations."
#   type        = map(any)
#   default     = {}
# }
variable "lifecycle_rule" {
  description = "List of lifecycle rules for the S3 bucket"
  type = list(object({
    id      = optional(string)
    enabled = optional(bool)
    status  = optional(string)
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    transition = optional(list(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    })))
    noncurrent_version_expiration = optional(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = optional(number)
    }))
    noncurrent_version_transition = optional(list(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = optional(number)
      storage_class             = string
    })))
    filter = optional(object({
      prefix                   = optional(string)
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      tags                     = optional(map(string))
      tag                      = optional(map(string))
    }))
  }))
  default = []
}

variable "intelligent_tiering" {
  description = "Intelligent tiering configuration."
  type = object({
    name   = optional(string)
    status = optional(string)
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    tiering = map(object({
      days = number
    }))
  })
  default = null
}

variable "metric_configuration" {
  description = "Bucket metric configuration."
  type = object({
    name = string
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
  })
  default = null
}

variable "analytics_configuration" {
  description = "Bucket analytics configuration."
  type = object({
    name = optional(string)
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    storage_class_analysis = object({
      data_export = object({
        destination = object({
          s3_bucket_destination = object({
            bucket_arn        = string
            format            = optional(string)
            bucket_account_id = optional(string)
            prefix            = optional(string)
          })
        })
      })
    })
  })
  default = null
}

variable "bucket_notifications" {
  description = "Notification configuration for SNS, SQS, or Lambda."
  type = object({
    queue          = optional(list(object({
      queue_arn     = string
      events        = list(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
      id            = optional(string)
    })), [])
    topic          = optional(list(object({
      topic_arn     = string
      events        = list(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
      id            = optional(string)
    })), [])
    lambda_function = optional(list(object({
      lambda_function_arn = string
      events              = list(string)
      filter_prefix       = optional(string)
      filter_suffix       = optional(string)
      id                  = optional(string)
    })), [])
    eventbridge = optional(bool, false)
  })
  default = null
}

variable "attach_policy" {
  description = "Controls if S3 bucket should have a bucket policy attached."
  type        = bool
  default     = false
}

variable "policy" {
  description = "A valid bucket policy JSON document."
  type        = string
  default     = null
}

variable "attach_elb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ELB log delivery policy attached."
  type        = bool
  default     = false
}

variable "attach_lb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ALB/NLB log delivery policy attached."
  type        = bool
  default     = false
}

variable "attach_deny_insecure_transport_policy" {
  description = "Controls if S3 bucket should have a deny non-SSL transport policy attached."
  type        = bool
  default     = true
}

variable "attach_require_latest_tls_policy" {
  description = "Controls if S3 bucket should require the latest version of TLS."
  type        = bool
  default     = true
}

variable "attach_inventory_destination_policy" {
  description = "Controls if S3 bucket should have bucket inventory destination policy attached."
  type        = bool
  default     = false
}

variable "inventory_source_account_id" {
  description = "The inventory source account ID."
  type        = string
  default     = null
}

variable "inventory_source_bucket_arn" {
  description = "The inventory source bucket ARN."
  type        = string
  default     = null
}

variable "inventory_self_source_destination" {
  description = "Whether the inventory source bucket is also the destination bucket."
  type        = bool
  default     = false
}

variable "inventory_configuration" {
  description = "S3 inventory configuration."
  type = object({
    name                     = optional(string)
    included_object_versions = string
    enabled                  = optional(bool)
    optional_fields          = optional(list(string))
    frequency                = string
    destination = object({
      bucket_arn = optional(string)
      format     = optional(string)
      account_id = optional(string)
      prefix     = optional(string)
      encryption = optional(object({
        encryption_type = string
        kms_key_id      = optional(string)
      }))
    })
    filter = optional(object({
      prefix = optional(string)
    }))
  })
  default = null
}

variable "attach_public_policy" {
  description = "Controls if a user-defined public bucket policy will be attached."
  type        = bool
  default     = true
}





variable "objects" {
  description = "List of S3 objects to create."
  type = list(object({
    key                 = string
    source              = optional(string)
    content             = optional(string)
    content_type        = optional(string)
    acl                 = optional(string)
    cache_control       = optional(string)
    content_disposition = optional(string)
    content_encoding    = optional(string)
    content_language    = optional(string)
    storage_class       = optional(string)
    etag                = optional(string)
    metadata            = optional(map(string), {})
    server_side_encryption = optional(string)
    kms_key_id          = optional(string)
    bucket_key_enabled  = optional(bool)
    tags                = optional(map(string), {})
    force_destroy       = optional(bool, false)
    object_lock_legal_hold_status = optional(string)
    object_lock_mode             = optional(string)
    object_lock_retain_until_date = optional(string)
  }))
  default = []
}

variable "object_copies" {
  description = "List of S3 object copies to create."
  type = list(object({
    key                 = string
    source              = string
    acl                 = optional(string)
    cache_control       = optional(string)
    content_disposition = optional(string)
    content_encoding    = optional(string)
    content_language    = optional(string)
    content_type        = optional(string)
    copy_if_match       = optional(string)
    copy_if_modified_since = optional(string)
    copy_if_none_match  = optional(string)
    copy_if_unmodified_since = optional(string)
    metadata            = optional(map(string), {})
    metadata_directive  = optional(string)
    server_side_encryption = optional(string)
    kms_key_id          = optional(string)
    storage_class       = optional(string)
    tagging_directive   = optional(string)
    tags                = optional(map(string), {})
    object_lock_legal_hold_status = optional(string)
    object_lock_mode             = optional(string)
    object_lock_retain_until_date = optional(string)
  }))
  default = []
}

variable "force_destroy" {
  description = "Whether to allow the bucket to be destroyed even if it contains objects."
  type        = bool
  default     = false
}

variable "object_lock_enabled" {
  description = "Whether S3 Object Lock is enabled for the bucket."
  type        = bool
  default     = false
}

variable "expected_bucket_owner" {
  description = "The AWS account ID of the expected bucket owner."
  type        = string
  default     = null
}

variable "acl" {
  description = "The canned ACL to apply to the bucket."
  type        = string
  default     = null
}