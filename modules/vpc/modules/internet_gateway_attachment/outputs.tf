output "attachment_id" {
  description = "The ID of the Internet Gateway Attachment (igw_id:vpc_id)"
  value       = aws_internet_gateway_attachment.this.id
}
