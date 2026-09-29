################################################################################
# Locals
################################################################################
locals {

  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a|4g){1}\\..*$/", "1") == "1" ? true : false

  ami = try(coalesce(var.ami, try(nonsensitive(data.aws_ssm_parameter.this[0].value), null)), null)
}

data "aws_ssm_parameter" "this" {
  count = var.create ? 1 : 0
  name  = var.ami_ssm_parameter
}

data "aws_partition" "current" {}

################################################################################
# Instance
################################################################################
resource "aws_instance" "this" {
  count         = var.create && !var.create_spot_instance ? 1 : 0
  ami           = try(coalesce(var.ami, data.aws_ssm_parameter.this[0].value), null)
  instance_type = var.instance_type
  hibernation   = var.hibernation
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change

  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  get_password_data           = var.get_password_data
  iam_instance_profile        = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  secondary_private_ips       = var.secondary_private_ips
  ipv6_addresses              = var.ipv6_addresses
  ebs_optimized               = var.ebs_optimized

#   resource "aws_ssm_parameter" "this" {
#   name  = "my-parameter-name"
#   type  = "String"
#   value = local.secure_type ? local.value : null

#   depends_on = [aws_instance.this]  # Ensure the EC2 instance is created first
# }




  dynamic "cpu_options" {
    for_each = (var.cpu_options == null ? 0 : length([for k, v in var.cpu_options : v if v != null])) > 0 ? [var.cpu_options] : []
    content {
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
      amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null)
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = (var.capacity_reservation_specification == null ? 0 : length([for k, v in var.capacity_reservation_specification : v if v != null])) > 0 ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)
      dynamic "capacity_reservation_target" {
        for_each = try(capacity_reservation_specification.value.capacity_reservation_target, null) != null ? [capacity_reservation_specification.value.capacity_reservation_target] : []
        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", false)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags                  = lookup(root_block_device.value, "general_tags", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", false)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
      instance_metadata_tags      = lookup(metadata_options.value, "instance_metadata_tags", null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
      }
  }

  dynamic "private_dns_name_options" {
    for_each = (var.private_dns_name_options == null ? 0 : length([for k, v in var.private_dns_name_options : v if v != null])) > 0 ? [var.private_dns_name_options] : []

    content {
      hostname_type                        = try(private_dns_name_options.value.hostname_type, null)
      enable_resource_name_dns_a_record    = try(private_dns_name_options.value.enable_resource_name_dns_a_record, null)
      enable_resource_name_dns_aaaa_record = try(private_dns_name_options.value.enable_resource_name_dns_aaaa_record, null)
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  dynamic "maintenance_options" {
    for_each = (var.maintenance_options == null ? 0 : length([for k, v in var.maintenance_options : v if v != null])) > 0 ? [var.maintenance_options] : []

    content {
      auto_recovery = try(maintenance_options.value.auto_recovery, null)
    }
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  disable_api_stop                     = var.disable_api_stop
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id
  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  tags        = merge(var.instance_tags, var.general_tags)
  volume_tags = var.enable_volume_tags ? merge(var.instance_tags, var.volume_tags) : null


}
################################################################################
# Instance - Ignore AMI Changes
################################################################################

resource "aws_instance" "ignore_ami" {
  count = var.create && var.ignore_ami_changes && !var.create_spot_instance ? 1 : 0

  ami                  = local.ami
  instance_type        = var.instance_type
  hibernation          = var.hibernation

  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change

  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name             = var.key_name
  monitoring           = var.monitoring
  get_password_data    = var.get_password_data
  iam_instance_profile = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile

  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized = var.ebs_optimized

  dynamic "cpu_options" {
    for_each = (var.cpu_options == null ? 0 : length([for k, v in var.cpu_options : v if v != null])) > 0 ? [var.cpu_options] : []

    content {
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
      amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null)
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = (var.capacity_reservation_specification == null ? 0 : length([for k, v in var.capacity_reservation_specification : v if v != null])) > 0 ? [var.capacity_reservation_specification] : []

    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)

      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification.value.capacity_reservation_target, "some_key", [])


        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device

    content {
      delete_on_termination = lookup(root_block_device.value.delete_on_termination, null)
      encrypted             = lookup(root_block_device.value.encrypted, null)
      iops                  = lookup(root_block_device.value.iops, null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value.volume_size, null)
      volume_type           = lookup(root_block_device.value.volume_type, null)
      throughput            = lookup(root_block_device.value.throughput, null)
      tags                  = lookup(root_block_device.value.tags, null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = lookup(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value.encrypted, null)
      iops                  = lookup(ebs_block_device.value.iops, null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value.volume_size, null)
      volume_type           = lookup(ebs_block_device.value.volume_type, null)
      throughput            = lookup(ebs_block_device.value.throughput, null)
      tags                  = lookup(ebs_block_device.value.tags, null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device

    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = try(ephemeral_block_device.value.no_device, null)
      virtual_name = try(ephemeral_block_device.value.virtual_name, null)
    }
  }

  dynamic "metadata_options" {
    for_each = (var.metadata_options == null ? 0 : length([for k, v in var.metadata_options : v if v != null])) > 0 ? [var.metadata_options] : []

    content {
      http_endpoint               = try(metadata_options.value.http_endpoint, "enabled")
      http_tokens                 = try(metadata_options.value.http_tokens, "optional")
      http_put_response_hop_limit = try(metadata_options.value.http_put_response_hop_limit, 1)
      instance_metadata_tags      = try(metadata_options.value.instance_metadata_tags, null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface

    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value.delete_on_termination, false)
    }
  }

  dynamic "private_dns_name_options" {
    for_each = (var.private_dns_name_options == null ? 0 : length([for k, v in var.private_dns_name_options : v if v != null])) > 0 ? [var.private_dns_name_options] : []

    content {
      hostname_type                        = try(private_dns_name_options.value.hostname_type, null)
      enable_resource_name_dns_a_record    = try(private_dns_name_options.value.enable_resource_name_dns_a_record, null)
      enable_resource_name_dns_aaaa_record = try(private_dns_name_options.value.enable_resource_name_dns_aaaa_record, null)
    }
  }

  dynamic "launch_template" {
    for_each = (var.launch_template == null ? 0 : length([for k, v in var.launch_template : v if v != null])) > 0 ? [var.launch_template] : []

    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  dynamic "maintenance_options" {
    for_each = (var.maintenance_options == null ? 0 : length([for k, v in var.maintenance_options : v if v != null])) > 0 ? [var.maintenance_options] : []

    content {
      auto_recovery = try(maintenance_options.value.auto_recovery, null)
    }
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  disable_api_stop                     = var.disable_api_stop
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags        = merge({ "Name" = var.name }, var.instance_tags, var.tags)
  volume_tags = var.enable_volume_tags ? merge({ "Name" = var.name }, var.volume_tags) : null

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}


################################################################################
# Spot Instance
################################################################################
resource "aws_spot_instance_request" "this" {
  count                       = var.create && var.create_spot_instance ? 1 : 0
  ami                         = try(coalesce(var.ami, data.aws_ssm_parameter.this[0].value), null)
  instance_type               = var.instance_type
  hibernation                 = var.hibernation
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  get_password_data           = var.get_password_data
  iam_instance_profile        = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses
  ebs_optimized               = var.ebs_optimized

  # Spot request specific attributes
  spot_price                     = var.spot_price
  wait_for_fulfillment           = var.spot_wait_for_fulfillment
  spot_type                      = var.spot_type
  launch_group                   = var.spot_launch_group
  instance_interruption_behavior = var.spot_instance_interruption_behavior
  valid_until                    = var.spot_valid_until
  valid_from                     = var.spot_valid_from
  # End spot request specific attributes

  dynamic "cpu_options" {
    for_each = (var.cpu_options == null ? 0 : length([for k, v in var.cpu_options : v if v != null])) > 0 ? [var.cpu_options] : []
    content {
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
      amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null)
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = (var.capacity_reservation_specification == null ? 0 : length([for k, v in var.capacity_reservation_specification : v if v != null])) > 0 ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)
      dynamic "capacity_reservation_target" {
for_each = lookup(capacity_reservation_specification.value.capacity_reservation_target, "some_key", [])
        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags                  = lookup(root_block_device.value, "general_tags", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id
  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
  }
  tags        = merge(var.spot_instance_request_tags, var.general_tags)
  volume_tags = var.enable_volume_tags ? merge(var.spot_instance_request_tags, var.volume_tags) : null
}

################################################################################
# IAM Role / Instance Profile
################################################################################
locals {
  iam_role_name = try(coalesce(var.iam_role_name, var.name), "")
}

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create && var.create_iam_instance_profile ? 1 : 0
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "this" {
  count                 = var.create && var.create_iam_instance_profile ? 1 : 0
  name                  = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix           = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path                  = var.iam_role_path
  description           = var.iam_role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true
  tags                  = merge(var.general_tags, var.iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = { for k, v in var.iam_role_policies : k => v if var.create && var.create_iam_instance_profile }
  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_instance_profile" "this" {
  count       = var.create && var.create_iam_instance_profile ? 1 : 0
  role        = aws_iam_role.this[0].name
  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path        = var.iam_role_path
  tags        = merge(var.general_tags, var.iam_instance_profile_tags)
  lifecycle {
    create_before_destroy = true
  }
}

#################################################################################
#aws_eip resource
#################################################################################
resource "aws_eip" "this" {
  count                     = var.create && var.associate_public_ip_address ? 1 : 0
  instance                  = aws_instance.this[0].id
  associate_with_private_ip = aws_instance.this[0].private_ip
  public_ipv4_pool          = var.public_ipv4_pool
  tags                      = merge(var.eip_tags, var.general_tags)
}


################################################################################
# AMI Creation
################################################################################
resource "aws_ami_from_instance" "this" {
  count         = var.create_image ? 1 : 0
  source_instance_id = var.instance_id
  name               = var.image_name
  description        = var.image_description
  tags               = merge(var.image_tags, var.general_tags)

  # Optional attributes
  # Ensure to remove this if not required
  # ebs_block_device {
  #   device_name           = "/dev/sda1"
  #   volume_type           = "gp3"
  #   volume_size           = 10
  #   delete_on_termination = true
  # }
}
################################################################################
# aws_key_pair
################################################################################
resource "aws_key_pair" "this" {
  count = var.create_key_pair ? 1 : 0

  key_name        = var.key_pair_name
  public_key      = var.key_pair_public_key
  key_name_prefix = var.key_pair_name_prefix
  tags            = var.key_pair_tags
}

################################################################################
# aws_launch_template
################################################################################
resource "aws_launch_template" "this" {
  count = var.create_launch_template ? 1 : 0

  name_prefix   = var.lt_name_prefix
  image_id      = var.lt_image_id
  instance_type = var.lt_instance_type
  key_name      = var.lt_key_name
  user_data     = var.lt_user_data

  ebs_optimized = var.lt_ebs_optimized
  iam_instance_profile {
    name = var.lt_iam_instance_profile_name
  }
  monitoring {
    enabled = var.lt_monitoring_enabled
  }
  network_interfaces {
    associate_public_ip_address = var.lt_associate_public_ip_address
    delete_on_termination       = var.lt_delete_on_termination
    device_index                = 0
    subnet_id                   = var.lt_subnet_id
    security_groups             = var.lt_security_group_ids
  }
  tag_specifications {
    resource_type = "instance"
    tags          = var.lt_template_tags
  }
}

################################################################################
# aws_placement_group
################################################################################
resource "aws_placement_group" "this" {
  count = var.create_placement_group ? 1 : 0

  name     = var.placement_group_name
  strategy = var.strategy
  partition_count = var.partition_count
  spread_level    = var.spread_level
  tags     = var.placement_group_tags
}

################################################################################
# aws_ami
################################################################################
resource "aws_ami" "this" {
  count = var.create_ami ? 1 : 0

  name                  = var.ami_name
  virtualization_type   = var.virtualization_type
  architecture          = var.architecture
  root_device_name      = var.root_device_name
  sriov_net_support     = var.sriov_net_support
  ena_support           = var.ena_support
  description           = var.ami_description
  imds_support          = var.imds_support
  boot_mode             = var.boot_mode
  deprecation_time      = var.deprecation_time
  tpm_support           = var.tpm_support
  uefi_data             = var.uefi_data
  tags                  = var.ami_tags

  dynamic "ebs_block_device" {
    for_each = var.ami_ebs_block_device
    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      outpost_arn           = lookup(ebs_block_device.value, "outpost_arn", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ami_ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }
}

################################################################################
# aws_ami_copy
################################################################################
resource "aws_ami_copy" "this" {
  count = var.create_ami_copy ? 1 : 0

  name              = var.ami_copy_name
  source_ami_id     = var.ami_copy_source_ami_id
  source_ami_region = var.ami_copy_source_region

  description            = var.ami_copy_description
  encrypted              = var.ami_copy_encrypted
  kms_key_id             = var.ami_copy_kms_key_id
  destination_outpost_arn = var.ami_copy_outpost_arn
  tags                   = var.ami_copy_tags
}

################################################################################
# aws_ami_launch_permission
################################################################################
resource "aws_ami_launch_permission" "this" {
  count = var.create_ami_launch_permission ? 1 : 0

  image_id   = var.image_id
  account_id = var.account_id
  group      = var.group
}

################################################################################
# aws_ec2_availability_zone_group
################################################################################
resource "aws_ec2_availability_zone_group" "this" {
  count = var.create_ec2_availability_zone_group ? 1 : 0

  group_name = var.group_name
  opt_in_status = var.opt_in_status
}

################################################################################
# aws_ec2_capacity_reservation
################################################################################
resource "aws_ec2_capacity_reservation" "this" {
  count = var.create_ec2_capacity_reservation ? 1 : 0

  instance_type                = var.ec2_capacity_instance_type
  instance_platform            = var.instance_platform
  availability_zone            = var.ec2_capacity_availability_zone
  instance_count               = var.instance_count
  tenancy                      = var.reservation_tenancy
  ebs_optimized                = var.ec2_capacity_ebs_optimized
  ephemeral_storage            = var.ephemeral_storage
  end_date_type                = var.end_date_type
  end_date                     = var.end_date
  tags                         = var.ec2_capacity_tags
}

################################################################################
# aws_ec2_fleet
################################################################################
resource "aws_ec2_fleet" "this" {
  count = var.create_ec2_fleet ? 1 : 0

  launch_template_config {
    launch_template_specification {
      launch_template_id = var.launch_template_id
      version            = var.launch_template_version
    }
  }

  target_capacity_specification {
    total_target_capacity = var.total_target_capacity
    default_target_capacity_type = var.default_target_capacity_type
  }

  replace_unhealthy_instances = var.replace_unhealthy_instances
  terminate_instances_with_expiration = var.terminate_instances_with_expiration
  type = var.fleet_type
}

################################################################################
# aws_ec2_host
################################################################################
resource "aws_ec2_host" "this" {
  count = var.create_ec2_host ? var.ec2_host_number_of_hosts : 0

  availability_zone = var.ec2_host_availability_zone
  instance_type     = var.ec2_host_instance_type
  auto_placement    = var.ec2_host_auto_placement
  host_recovery     = var.ec2_host_recovery
  outpost_arn       = var.ec2_host_outpost_arn
  tags              = var.ec2_host_tags
}