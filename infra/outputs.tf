output "vpc_id" {
  description = "ID of the demo VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "bucket_name" {
  description = "Name of the demo S3 bucket"
  value       = module.s3.s3_bucket_id
}

output "bucket_arn" {
  description = "ARN of the demo S3 bucket"
  value       = module.s3.s3_bucket_arn
}

output "ec2_instance_id" {
  description = "ID of the demo EC2 instance"
  value       = module.ec2.id
}

output "ec2_private_ip" {
  description = "Private IP of the demo EC2 instance"
  value       = module.ec2.private_ip
}
