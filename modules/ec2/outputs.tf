################################################################################
# Instance Outputs
################################################################################
output "id" {
  description = "The ID of the instance"
  value       = try(aws_instance.this[0].id, aws_spot_instance_request.this[0].id, "")
}

output "arn" {
  description = "The ARN of the instance"
  value       = try(aws_instance.this[0].arn, aws_spot_instance_request.this[0].arn, "")
}

output "instance_ami" {
  description = "AMI ID"
  value       = try(aws_instance.this[0].ami, aws_spot_instance_request.this[0].ami, "")
  sensitive   = true
}

output "instance_type" {
  description = "AMI ID"
  value       = try(aws_instance.this[0].instance_type, aws_spot_instance_request.this[0].instance_type, "")
  sensitive   = true
}

output "capacity_reservation_specification" {
  description = "Capacity reservation specification of the instance"
  value       = try(aws_instance.this[0].capacity_reservation_specification, aws_spot_instance_request.this[0].capacity_reservation_specification, "")
}

output "instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = try(aws_instance.this[0].instance_state, aws_spot_instance_request.this[0].instance_state, "")
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to"
  value       = try(aws_instance.this[0].outpost_arn, aws_spot_instance_request.this[0].outpost_arn, "")
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance. Useful for getting the administrator password for instances running Microsoft Windows. This attribute is only exported if `get_password_data` is true"
  value       = try(aws_instance.this[0].password_data, aws_spot_instance_request.this[0].password_data, "")
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = try(aws_instance.this[0].primary_network_interface_id, aws_spot_instance_request.this[0].primary_network_interface_id, "")
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = try(aws_instance.this[0].private_dns, aws_spot_instance_request.this[0].private_dns, "")
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = try(aws_instance.this[0].public_dns, aws_spot_instance_request.this[0].public_dns, "")
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = try(aws_instance.this[0].public_ip, aws_spot_instance_request.this[0].public_ip, "")
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value       = try(aws_instance.this[0].private_ip, aws_spot_instance_request.this[0].private_ip, "")
}

output "ipv6_addresses" {
  description = "The IPv6 address assigned to the instance, if applicable."
  value       = try(aws_instance.this[0].ipv6_addresses, [])
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = try(aws_instance.this[0].tags_all, aws_spot_instance_request.this[0].tags_all, {})
}

output "spot_bid_status" {
  description = "The current bid status of the Spot Instance Request"
  value       = try(aws_spot_instance_request.this[0].spot_bid_status, "")
}

output "spot_request_state" {
  description = "The current request state of the Spot Instance Request"
  value       = try(aws_spot_instance_request.this[0].spot_request_state, "")
}

output "spot_instance_id" {
  description = "The Instance ID (if any) that is currently fulfilling the Spot Instance request"
  value       = try(aws_spot_instance_request.this[0].spot_instance_id, "")
}

################################################################################
# IAM Role / Instance Profile
################################################################################
output "iam_role_name" {
  description = "The name of the IAM role"
  value       = try(aws_iam_role.this[0].name, null)
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = try(aws_iam_role.this[0].unique_id, null)
}

output "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = try(aws_iam_instance_profile.this[0].id, null)
}

output "iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].unique_id, null)
}
output "elastic_ip" {
  description = "Public IP address of the Elastic IP"
  value       = try(aws_eip.this[0].public_ip, "")
}

################################################################################
# AMI Outputs
################################################################################
output "ami_id" {
  description = "The ID of the newly created AMI"
  value       = try(aws_ami_from_instance.this[0].id, "")
}

output "ami_name" {
  description = "The name of the newly created AMI"
  value       = try(aws_ami_from_instance.this[0].name, "")
}

################################################################################
# aws_key_pair
################################################################################
output "key_pair_name" {
  value = try(aws_key_pair.this[0].key_name, null)
  description = "Name of the key pair created"
}
# output "key_pair_fingerprint" {
#   value = try(aws_key_pair.this[0].key_fingerprint, null)
# }
output "key_pair_arn" {
  value = try(aws_key_pair.this[0].arn, null)
}

################################################################################
# aws_launch_template
################################################################################
output "launch_template_id" {
  value = try(aws_launch_template.this[0].id, null)
}
output "launch_template_name" {
  value = try(aws_launch_template.this[0].name, null)
}

################################################################################
# aws_placement_group
################################################################################
output "placement_group_id" {
  value = try(aws_placement_group.this[0].id, null)
}

################################################################################
# aws_ami_copy
################################################################################
output "ami_copy_id" {
  value = try(aws_ami_copy.this[0].id, null)
}

output "ami_copy_arn" {
  value = try(aws_ami_copy.this[0].arn, null)
}

output "ami_copy_name" {
  value = try(aws_ami_copy.this[0].name, null)
}

################################################################################
# aws_ami_launch_permission
################################################################################
output "ami_launch_permission_image_id" {
  value = try(aws_ami_launch_permission.this[0].image_id, null)
}

################################################################################
# aws_ec2_availability_zone_group
################################################################################
output "availability_zone_group_name" {
  value = try(aws_ec2_availability_zone_group.this[0].group_name, null)
}

################################################################################
# aws_ec2_capacity_reservation
################################################################################
output "capacity_reservation_id" {
  value = try(aws_ec2_capacity_reservation.this[0].id, null)
}

################################################################################
# aws_ec2_fleet
################################################################################
output "ec2_fleet_id" {
  value = try(aws_ec2_fleet.this[0].id, null)
}

################################################################################
# aws_ec2_host
################################################################################
output "ec2_host_id" {
  value = try(aws_ec2_host.this[0].id, null)
}