variable "manage_default_vpc" {
  description = "Flag to manage the default VPC"
  type        = bool
}

variable "default_vpc_enable_dns_support" {
  description = "Enable DNS support on the default VPC"
  type        = bool
}

variable "default_vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames on the default VPC"
  type        = bool
}

variable "default_vpc_tags" {
  description = "Tags to apply specifically to the default VPC"
  type        = map(string)
}

variable "general_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
