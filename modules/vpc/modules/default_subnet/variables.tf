variable "availability_zone" {
  description = "The Availability Zone for the default subnet"
  type        = string
}

variable "force_destroy" {
  description = "Whether destroying the resource deletes the default subnet"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to the default subnet"
  type        = map(string)
}
