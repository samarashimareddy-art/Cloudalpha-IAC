provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = "cloudalpha-demo"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

locals {
  name = "cloudalpha-demo-${var.environment}"
}

################################################################################
# VPC - cloudalpha-aws-vpc module
# Demo-sized: one public subnet + internet gateway. No NAT gateway (~$32/month)
# and no flow logs, to keep the demo cheap and quick to create/destroy.
################################################################################
module "vpc" {
  source = "../modules/vpc"

  create_vpc = true
  vpc_config = {
    name                 = "${local.name}-vpc"
    ipv4_cidr            = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"
  }

  public_subnets = [
    {
      cidr_block              = var.public_subnet_cidr
      availability_zone       = "${var.region}a"
      map_public_ip_on_launch = false
    }
  ]
  private_subnets = []

  create_internet_gateway   = true
  create_nat_gateway        = false
  create_public_route_table = true
  public_route_table_routes = {
    internet = {
      cidr_block   = "0.0.0.0/0"
      internal_igw = true
    }
  }
  create_private_route_table      = false
  create_route_table_associations = true
  enable_flow_logs                = false

  general_tags          = { Project = "cloudalpha-demo" }
  vpc_tags              = { Name = "${local.name}-vpc" }
  internet_gateway_tags = { Name = "${local.name}-igw" }
  public_route_table_tags = {
    Name = "${local.name}-rt-public"
  }
}

################################################################################
# Security group for the EC2 instance - no inbound access, outbound only.
################################################################################
resource "aws_security_group" "ec2" {
  name        = "${local.name}-ec2-sg"
  description = "Cloudalpha demo EC2 - no inbound, outbound only"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Outbound HTTPS/HTTP for OS updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-ec2-sg" }
}

################################################################################
# S3 - cloudalpha-aws-s3 module
# Same bucket the first pipeline run created with plain resources; the import
# block below adopts it into this module instead of trying to create it again.
################################################################################
import {
  to = module.s3.aws_s3_bucket.this[0]
  id = "cloudalpha-demo-${var.environment}-${var.suffix}"
}

module "s3" {
  source = "../modules/s3"

  create_bucket = true
  bucket        = "cloudalpha-demo-${var.environment}-${var.suffix}"
  force_destroy = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # Public access block + HTTPS-only policies (module defaults), no other policies.
  attach_policy                         = false
  attach_elb_log_delivery_policy        = false
  attach_lb_log_delivery_policy         = false
  attach_inventory_destination_policy   = false
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  tags = { Name = "${local.name}-bucket" }
}

################################################################################
# EC2 - cloudalpha-aws-ec2 module
# The module requires an explicit AMI ID and an existing key pair name, so both
# are provided here. No public IP, no inbound rules, no IAM instance profile.
################################################################################
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

# Key pair the module requires. The instance has no inbound access, so the key
# is only there to satisfy the module; the private key stays in encrypted state.
resource "tls_private_key" "ec2" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "ec2" {
  key_name   = "${local.name}-key"
  public_key = tls_private_key.ec2.public_key_openssh
}

module "ec2" {
  source = "../modules/ec2"

  name                        = "${local.name}-app"
  instance_type               = var.instance_type
  ami                         = data.aws_ami.al2023.id
  key_name                    = aws_key_pair.ec2.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = false
  monitoring                  = false

  create_iam_instance_profile = false

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 8
    }
  ]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2 only
    http_put_response_hop_limit = 1
  }

  tags = { Name = "${local.name}-app" }
}
