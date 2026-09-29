variable "bucket_name" {
  description = "Name of the S3 bucket to attach the policy to"
  type        = string
}

variable "policy_json_file" {
  description = "Path to JSON file containing S3 bucket policy"
  type        = string
  default     = null
}

variable "policy_json_string" {
  description = "JSON string containing S3 bucket policy"
  type        = string
  default     = null
}

variable "enable_elb_log_delivery" {
  description = "Enable ELB log delivery policy"
  type        = bool
  default     = false
}

variable "enable_lb_log_delivery" {
  description = "Enable ALB/NLB log delivery policy"
  type        = bool
  default     = false
}

variable "enable_deny_insecure_transport" {
  description = "Enable policy to deny insecure transport"
  type        = bool
  default     = false
}

variable "enable_require_latest_tls" {
  description = "Enable policy to require latest TLS version"
  type        = bool
  default     = false
}

variable "enable_inventory_destination" {
  description = "Enable S3 inventory destination policy"
  type        = bool
  default     = false
}