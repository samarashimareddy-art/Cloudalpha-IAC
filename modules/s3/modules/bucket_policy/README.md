# S3 Bucket Policy Module

This module creates and manages S3 bucket policies with support for custom policies and standard AWS service policies.

## Features

- Custom policy from JSON file or inline string
- Standard AWS service policies (ELB, ALB/NLB logs, security policies)
- Multiple policy combination support
- Secure transport enforcement
- TLS version requirements

## Usage

```hcl
module "s3_bucket_policy" {
  source = "./modules/bucket_policy"

  bucket_name                     = "my-bucket"
  policy_json_file               = "policy.json"
  enable_deny_insecure_transport = true
  enable_require_latest_tls      = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | Name of the S3 bucket | `string` | n/a | yes |
| policy_json_file | Path to JSON policy file | `string` | `null` | no |
| policy_json_string | JSON policy string | `string` | `null` | no |
| enable_elb_log_delivery | Enable ELB log delivery policy | `bool` | `false` | no |
| enable_lb_log_delivery | Enable ALB/NLB log delivery policy | `bool` | `false` | no |
| enable_deny_insecure_transport | Deny insecure transport | `bool` | `false` | no |
| enable_require_latest_tls | Require latest TLS version | `bool` | `false` | no |
| enable_inventory_destination | Enable inventory destination policy | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_policy_id | The bucket policy ID |
| bucket_policy_json | The JSON policy document |