variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate with the security group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
}

variable "ingress_rules" {
  description = <<EOT
List of ingress rules to create.
Each rule is an object with:
- from_port
- to_port
- protocol
- description
- cidr_ipv4 (optional)
- cidr_ipv6 (optional)
- prefix_list_id (optional)
EOT
  type = list(object({
    from_port      = number
    to_port        = number
    protocol       = string
    description    = string
    cidr_ipv4      = optional(string)
    cidr_ipv6      = optional(string)
    prefix_list_id = optional(string)
  }))
}

variable "egress_rules" {
  description = "List of egress rules to create (same format as ingress)"
  type = list(object({
    from_port      = number
    to_port        = number
    protocol       = string
    description    = string
    cidr_ipv4      = optional(string)
    cidr_ipv6      = optional(string)
    prefix_list_id = optional(string)
  }))
}

variable "enable_custom_timeout" {
  description = "Whether to set a custom delete timeout"
  type        = bool
}

variable "timeout_delete" {
  description = "Custom delete timeout duration (e.g., '45m')"
  type        = string
}
