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

output "ecr_repository_url" {
  description = "Where the Cloudalpha-App pipeline pushes its image"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster running the app"
  value       = aws_ecs_cluster.app.name
}

output "ecs_service_name" {
  description = "ECS service the app pipeline redeploys"
  value       = aws_ecs_service.app.name
}

output "ec2_private_ip" {
  description = "Private IP of the demo EC2 instance"
  value       = module.ec2.private_ip
}
