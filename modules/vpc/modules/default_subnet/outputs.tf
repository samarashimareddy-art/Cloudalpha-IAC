output "id" {
  description = "The ID of the default subnet"
  value       = aws_default_subnet.this.id
}

output "availability_zone" {
  description = "The availability zone of the default subnet"
  value       = aws_default_subnet.this.availability_zone
}

output "availability_zone_id" {
  description = "The AZ ID of the subnet"
  value       = aws_default_subnet.this.availability_zone_id
}

output "cidr_block" {
  description = "The IPv4 CIDR block assigned to the subnet"
  value       = aws_default_subnet.this.cidr_block
}

output "vpc_id" {
  description = "The ID of the VPC the subnet is in"
  value       = aws_default_subnet.this.vpc_id
}

output "tags_all" {
  description = "All tags including provider default tags"
  value       = aws_default_subnet.this.tags_all
}
