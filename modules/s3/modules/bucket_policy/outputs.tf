output "bucket_policy_id" {
  description = "The bucket policy ID"
  value       = aws_s3_bucket_policy.this.id
}

output "bucket_policy_json" {
  description = "The JSON policy document"
  value       = data.aws_iam_policy_document.combined.json
}