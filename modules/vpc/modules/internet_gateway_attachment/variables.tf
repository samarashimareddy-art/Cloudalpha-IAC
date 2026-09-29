variable "internet_gateway_id" {
  description = "The ID of the Internet Gateway to attach"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to attach the Internet Gateway to"
  type        = string
}
