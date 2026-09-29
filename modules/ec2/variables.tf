################################################################################
# General tags
################################################################################

variable "general_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "spot_instance_request_tags" {
  type    = map(string)
  default = {}
}

# variable "instance_tags" {
#   type    = map(string)
#   default = {}
# }


################################################################################
# EC2 Instance Configuration Variables
################################################################################
variable "create" {
  description = "Whether to create an instance"
  type        = bool
  default     = true
}


variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "ami_ssm_parameter" {
  description = "SSM parameter name for the AMI ID. For Amazon Linux AMI SSM parameters see [reference](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html)"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "ami" {
  description = "AMI ID for the instance"
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]{8,17}$", var.ami))
    error_message = "ami must look like ami-xxxxxxxx or ami-xxxxxxxxxxxxxxxxx (hex)."
  }
}

variable "ignore_ami_changes" {
  description = "Whether changes to the AMI ID changes should be ignored by Terraform. Note - changing this value will result in the replacement of the instance"
  type        = bool
  default     = false
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
  }

variable "maintenance_options" {
  description = "The maintenance options for the instance"
  type = object({
    auto_recovery = optional(string)
  })
  default = {}
}

variable "availability_zone" {
  description = "AZ to start the instance in (e.g., us-east-1a)"
  type        = string
  default     = null

  validation {
    condition     = var.availability_zone == null || can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.availability_zone))
    error_message = "availability_zone must look like ap-southeast-1a, us-east-1a, etc."
  }
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type = object({
    capacity_reservation_preference = optional(string)
    capacity_reservation_target = optional(object({
      capacity_reservation_id                 = optional(string)
      capacity_reservation_resource_group_arn = optional(string)
    }))
  })
  default = {}
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = null
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type = list(object({
    device_name           = string
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    snapshot_id           = optional(string)
    volume_size           = optional(number)
    volume_type           = optional(string)
    throughput            = optional(number)
    tags                  = optional(map(string))
  }))
  default = []
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "enclave_options_enabled" {
  description = "Whether Nitro Enclaves will be enabled on the instance. Defaults to `false`"
  type        = bool
  default     = null
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type = list(object({
    device_name  = string
    no_device    = optional(bool)
    virtual_name = optional(string)
  }))
  default = []
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = bool
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = null
}

variable "host_id" {
  description = "ID of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t3.micro)"
  type        = string

  validation {
    condition     = trimspace(var.instance_type) != "" && can(regex("^[a-z0-9.]+$", var.instance_type))
    error_message = "instance_type cannot be empty and must match lowercase letters, numbers, and dots (e.g., t3.micro)."
  }
}


variable "instance_tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet"
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = null
}

variable "key_name" {
  description = "Existing key pair name"
  type        = string

  validation {
    condition     = trimspace(var.key_name) != ""
    error_message = "key_name cannot be empty."
  }
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template"
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = optional(string)
  })
  default = null
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    instance_metadata_tags      = optional(string)
  })
  default = {}
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type = list(object({
    device_index          = number
    network_interface_id  = optional(string)
    delete_on_termination = optional(bool)
  }))
  default = []
}

variable "private_dns_name_options" {
  description = "Customize the private DNS name options of the instance"
  type = object({
    hostname_type                        = optional(string)
    enable_resource_name_dns_a_record    = optional(bool)
    enable_resource_name_dns_aaaa_record = optional(bool)
  })
  default = {}
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type = list(object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    volume_size           = optional(number)
    volume_type           = optional(string)
    throughput            = optional(number)
    tags                  = optional(map(string))
    general_tags          = optional(map(string))
  }))
  default = []
}

variable "secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block`"
  type        = list(string)
  default     = null
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Subnet ID to launch into"
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-fA-F]{8,17}$", var.subnet_id))
    error_message = "subnet_id must look like subnet-xxxxxxxx or subnet-xxxxxxxxxxxxxxxxx (hex)."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set."
  type        = bool
  default     = false
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "enable_volume_tags" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "Security group IDs to associate"
  type        = list(string)

  validation {
    condition     = length(var.vpc_security_group_ids) > 0 && alltrue([for sg in var.vpc_security_group_ids : can(regex("^sg-[0-9a-fA-F]{8,17}$", sg))])
    error_message = "Provide at least one valid sg-xxxxxxxx… security group ID."
  }
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {}
}

variable "cpu_options" {
  description = "Defines CPU options to apply to the instance at launch time."
  type = object({
    core_count       = optional(number)
    threads_per_core = optional(number)
    amd_sev_snp      = optional(string)
  })
  default = {}
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance" # This option is only supported on creation of instance type that support CPU Options https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set)"
  type        = number
  default     = null
}

# Spot instance request
variable "create_spot_instance" {
  description = "Depicts if the instance is a spot instance"
  type        = bool
  default     = false
}

variable "spot_price" {
  description = "The maximum price to request on the spot market. Defaults to on-demand price"
  type        = string
  default     = null
}

variable "spot_wait_for_fulfillment" {
  description = "If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached"
  type        = bool
  default     = null
}

variable "spot_type" {
  description = "If set to one-time, after the instance is terminated, the spot request will be closed. Default `persistent`"
  type        = string
  default     = null
}

variable "spot_launch_group" {
  description = "A launch group is a group of spot instances that launch together and terminate together. If left empty instances are launched and terminated individually"
  type        = string
  default     = null
}

variable "spot_block_duration_minutes" {
  description = "The required duration for the Spot instances, in minutes. This value must be a multiple of 60 (60, 120, 180, 240, 300, or 360)"
  type        = number
  default     = null
}

variable "spot_instance_interruption_behavior" {
  description = "Indicates Spot instance behavior when it is interrupted. Valid values are `terminate`, `stop`, or `hibernate`"
  type        = string
  default     = null
}

variable "spot_valid_until" {
  description = "The end date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
}

variable "spot_valid_from" {
  description = "The start date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection."
  type        = bool
  default     = null

}

################################################################################
# IAM Role / Instance Profile Configuration Variables
################################################################################
variable "create_iam_instance_profile" {
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name` or `name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_policies" {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}

variable "iam_instance_profile_tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}


################################################################################
# Miscellaneous Configuration Variables
################################################################################
variable "public_ipv4_pool" {
  description = "EC2 IPv4 address pool identifier (if in VPC)."
  type        = string
  default     = "amazon"
}

variable "eip_tags" {
  type    = map(string)
  default = {}
}

################################################################################
# AMI Creation Variables
################################################################################
variable "create_image" {
  description = "Whether to create an AMI from the instance"
  type        = bool
  default     = false
}

variable "instance_id" {
  description = "The ID of the instance from which to create the image"
  type        = string
  default     = ""
}

variable "image_name" {
  description = "Name of the AMI to be created"
  type        = string
  default     = ""
}

variable "image_description" {
  description = "Description of the AMI"
  type        = string
  default     = ""
}

variable "image_tags" {
  description = "Tags to assign to the created AMI"
  type        = map(string)
  default     = {}
}

################################################################################
# aws_key_pair
################################################################################
variable "create_key_pair" {
  description = "Whether to create the key pair"
  type        = bool
  default     = false
}

variable "key_pair_name" {
  description = "Name for the key pair"
  type        = string
  default     = null
}

variable "key_pair_public_key" {
  description = "Public key material"
  type        = string
  default     = null
}

variable "key_pair_name_prefix" {
  description = "Creates a unique key name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "key_pair_tags" {
  description = "A map of tags to assign to the key pair"
  type        = map(string)
  default     = {}
}

################################################################################
# aws_launch_template
################################################################################
variable "create_launch_template" {
  type    = bool
  default = false
}

variable "lt_name_prefix" {
  type    = string
  default = null
}
variable "lt_image_id" {
  type    = string
  default = null
}

variable "lt_instance_type" {
  type    = string
  default = null
}

variable "lt_key_name" {
  type    = string
  default = null
}


variable "lt_user_data" {
  type    = string
  default = null
}

variable "lt_ebs_optimized" {
  type    = bool
  default = null
}

variable "lt_iam_instance_profile_name" {
  type    = string
  default = null
}

variable "lt_monitoring_enabled" {
  type    = bool
  default = false
}

variable "lt_associate_public_ip_address" {
  type    = bool
  default = false
}

variable "lt_delete_on_termination" {
  type    = bool
  default = true
}

variable "lt_subnet_id" {
  type    = string
  default = null
}

variable "lt_security_group_ids" {
  type    = list(string)
  default = []
}

variable "lt_template_tags" {
  type    = map(string)
  default = {}
}

################################################################################
# aws_placement_group
################################################################################
variable "create_placement_group" {
  type    = bool
  default = false
}

variable "placement_group_name" {
  type    = string
  default = null
}

variable "strategy" {
  type    = string
  default = "cluster"
}

variable "partition_count" {
  type    = number
  default = null
}

variable "spread_level" {
  type    = string
  default = null
}

variable "placement_group_tags" {
  type    = map(string)
  default = {}
}

################################################################################
# aws_ami
################################################################################
variable "create_ami" {
  description = "Whether to create the AMI"
  type        = bool
  default     = false
}

variable "ami_name" {
  description = "Region-unique name for the AMI"
  type        = string
  default     = null
}

variable "virtualization_type" {
  description = "Keyword to choose the virtualization mode: 'paravirtual' or 'hvm'"
  type        = string
  default     = "hvm"
}

variable "architecture" {
  description = "Machine architecture (e.g., x86_64, arm64)"
  type        = string
  default     = "x86_64"
}

variable "root_device_name" {
  description = "Name of the root device (e.g., /dev/sda1, /dev/xvda)"
  type        = string
  default     = null
}

variable "sriov_net_support" {
  description = "Enable enhanced networking for created instances ('simple')"
  type        = string
  default     = null
}

variable "ena_support" {
  description = "Whether enhanced networking with ENA is enabled"
  type        = bool
  default     = null
}

variable "ami_description" {
  description = "Longer, human-readable description for the AMI"
  type        = string
  default     = null
}

variable "imds_support" {
  description = "If EC2 instances started from this image should require use of IMDSv2 ('v2.0')"
  type        = string
  default     = null
}

variable "boot_mode" {
  description = "Boot mode of the AMI. For example, 'uefi' or 'legacy-bios'"
  type        = string
  default     = null
}

variable "deprecation_time" {
  description = "Date and time to deprecate the AMI (RFC3339 format)"
  type        = string
  default     = null
}

variable "tpm_support" {
  description = "If image is configured for NitroTPM support, set to 'v2.0'"
  type        = string
  default     = null
}

variable "uefi_data" {
  description = "Base64 representation of non-volatile UEFI variable store"
  type        = string
  default     = null
}

variable "ami_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
variable "ami_ebs_block_device" {
  description = "EBS block devices for AMI"
  type = list(object({
    device_name           = string
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    snapshot_id           = optional(string)
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
    outpost_arn           = optional(string)
  }))
  default = []
}

variable "ami_ephemeral_block_device" {
  description = "List of ephemeral block device mappings"
  type        = list(object({
    device_name  = string
    virtual_name = string
  }))
  default = []
}

################################################################################
# aws_ami_copy
################################################################################
variable "create_ami_copy" {
  description = "Whether to create an AMI copy"
  type        = bool
  default     = false
}

variable "ami_copy_name" {
  description = "Name of the new AMI copy"
  type        = string
  default     = null
}

variable "ami_copy_source_ami_id" {
  description = "Source AMI ID to copy"
  type        = string
  default     = null
}

variable "ami_copy_source_region" {
  description = "Source region of the AMI"
  type        = string
  default     = null
}

variable "ami_copy_description" {
  description = "Description of the copied AMI"
  type        = string
  default     = null
}

variable "ami_copy_encrypted" {
  description = "Whether the destination snapshots should be encrypted"
  type        = bool
  default     = false
}

variable "ami_copy_kms_key_id" {
  description = "KMS Key ARN to encrypt snapshots"
  type        = string
  default     = null
}

variable "ami_copy_outpost_arn" {
  description = "ARN of the Outpost to copy the AMI to (optional)"
  type        = string
  default     = null
}

variable "ami_copy_tags" {
  description = "Tags to assign to the AMI copy"
  type        = map(string)
  default     = {}
}

################################################################################
# aws_ami_launch_permission
################################################################################
variable "create_ami_launch_permission" {
  description = "Whether to create an AMI launch permission"
  type        = bool
  default     = false
}

variable "image_id" {
  description = "ID of the AMI"
  type        = string
  default = null
}

variable "account_id" {
  description = "AWS Account ID to share the AMI with"
  type        = string
  default     = null
}

variable "group" {
  description = "Group to share with, usually 'all' for public sharing"
  type        = string
  default     = null
}

################################################################################
# aws_ec2_availability_zone_group
################################################################################
variable "create_ec2_availability_zone_group" {
  description = "Whether to create EC2 availability zone group"
  type        = bool
  default     = false
}

variable "group_name" {
  description = "Name of the availability zone group"
  type        = string
  default = null
}

variable "opt_in_status" {
  description = "The opt-in status. Valid values: 'opted-in', 'not-opted-in'"
  type        = string
  default = null
}

################################################################################
# aws_ec2_capacity_reservation
################################################################################
variable "create_ec2_capacity_reservation" {
  description = "Whether to create EC2 capacity reservation"
  type        = bool
  default     = false
}

variable "ec2_capacity_instance_type" {
  description = "The type of instance for which to reserve capacity"
  type        = string
  default = null
}

variable "instance_platform" {
  description = "The type of operating system for which to reserve capacity"
  type        = string
  default = null
}

variable "ec2_capacity_availability_zone" {
  description = "The Availability Zone in which to create the reservation"
  type        = string
  default = null
}

variable "instance_count" {
  description = "Number of instances to reserve"
  type        = number
  default     = 1
}

variable "reservation_tenancy" {
  description = "Indicates whether the reservation is for shared or dedicated tenancy instances"
  type        = string
  default     = null
}

variable "ec2_capacity_ebs_optimized" {
  description = "Indicates whether the reservation supports EBS-optimized instances"
  type        = bool
  default     = false
}

variable "ephemeral_storage" {
  description = "Indicates whether the reservation supports instances with ephemeral storage"
  type        = bool
  default     = false
}

variable "end_date_type" {
  description = "Indicates the way in which the Capacity Reservation ends"
  type        = string
  default     = null
}

variable "end_date" {
  description = "The date and time at which the Capacity Reservation expires"
  type        = string
  default     = null
}

variable "ec2_capacity_tags" {
  description = "A map of tags to assign to the reservation"
  type        = map(string)
  default     = {}
}

################################################################################
# aws_ec2_fleet
################################################################################
variable "create_ec2_fleet" {
  description = "Whether to create EC2 fleet"
  type        = bool
  default     = false
}

variable "launch_template_id" {
  description = "Launch template ID"
  type        = string
  default = null
}

variable "launch_template_version" {
  description = "Launch template version"
  type        = string
  default = null
}

variable "total_target_capacity" {
  description = "Total target capacity for the fleet"
  type        = number
  default = null
}

variable "default_target_capacity_type" {
  description = "Default type for target capacity (spot or on-demand)"
  type        = string
  default = null
}

variable "replace_unhealthy_instances" {
  description = "Whether to replace unhealthy instances"
  type        = bool
  default     = false
}

variable "terminate_instances_with_expiration" {
  description = "Whether to terminate instances when fleet expires"
  type        = bool
  default     = false
}

variable "fleet_type" {
  description = "Type of fleet (maintain, request, or instant)"
  type        = string
  default     = "maintain"
}

################################################################################
# aws_ec2_host
################################################################################
variable "create_ec2_host" {
  description = "Whether to create EC2 host"
  type        = bool
  default     = false
}

variable "ec2_host_availability_zone" {
  description = "Availability Zone of the host"
  type        = string
  default = null
}

variable "ec2_host_instance_type" {
  description = "Instance type supported by the dedicated host"
  type        = string
  default = null
}

variable "ec2_host_quantity" {
  description = "Number of hosts to allocate"
  type        = number
  default = null
}

variable "ec2_host_auto_placement" {
  description = "Whether auto placement is enabled"
  type        = string
  default     = "on"
}

variable "ec2_host_tags" {
  description = "Tags to assign to the host"
  type        = map(string)
  default     = {}
}

variable "ec2_host_recovery" {
  description = "Whether to enable host recovery for the host ('on' or 'off')"
  type        = string
  default     = "off"
}
variable "ec2_host_number_of_hosts" {
  description = "Number of Dedicated Hosts to create"
  type        = number
  default     = 1
}

variable "ec2_host_outpost_arn" {
  description = "ARN of Outpost if host is part of an Outpost"
  type        = string
  default     = null
}