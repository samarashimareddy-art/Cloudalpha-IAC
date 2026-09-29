# Complete VPC Module

This is a comprehensive wrapper module that creates a complete VPC infrastructure with all essential networking components in AWS. It leverages existing individual modules to provide a unified interface for creating VPC resources.

## Features

- **Single VPC Creation**: Creates one VPC per module instance
- **Flexible Component Control**: Enable/disable components via boolean flags
- **Comprehensive Networking**: Supports all major VPC components
- **Existing Module Leverage**: Uses proven individual modules
- **Structured Configuration**: Uses lists of maps/objects for complex configurations

## Components Included

- ✅ VPC Core (with IPv4/IPv6 support)
- ✅ Public and Private Subnets
- ✅ Internet Gateway
- ✅ NAT Gateways (Public and Private)
- ✅ Route Tables (Public and Private)
- ✅ Route Table Associations
- ✅ Security Groups
- ✅ Network ACLs
- ✅ VPC Flow Logs

## Usage

### Basic VPC with Public Subnets

```hcl
module "vpc" {
  source = "./path/to/this/module"

  # VPC Configuration
  vpc_config = [{
    name                 = "my-vpc"
    ipv4_cidr           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
  }]

  # Public Subnets
  public_subnets = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-west-2a"
      map_public_ip_on_launch = true
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-west-2b"
      map_public_ip_on_launch = true
    }
  ]

  general_tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

### Complete VPC with Private Subnets and NAT Gateway

```hcl
module "vpc" {
  source = "./path/to/this/module"

  # VPC Configuration
  vpc_config = [{
    name                 = "production-vpc"
    ipv4_cidr           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
  }]

  # Public Subnets
  public_subnets = [
    {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-west-2a"
      map_public_ip_on_launch = true
    },
    {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-west-2b"
      map_public_ip_on_launch = true
    }
  ]

  # Private Subnets
  private_subnets = [
    {
      cidr_block        = "10.0.10.0/24"
      availability_zone = "us-west-2a"
    },
    {
      cidr_block        = "10.0.20.0/24"
      availability_zone = "us-west-2b"
    }
  ]

  # NAT Gateway Configuration
  create_nat_gateway        = true
  enable_public_nat_gateway = true
  single_public_nat_gateway = true

  # Private Route Tables
  private_route_tables = [
    { name = "private-rt-1" }
  ]

  private_route_table_routes = [
    [
      {
        cidr_block                  = "0.0.0.0/0"
        internal_public_nat_gateway = true
      }
    ]
  ]

  # Enable Flow Logs
  enable_flow_logs              = true
  flow_log_destination_type     = "cloud-watch-logs"
  flow_log_destination_arn      = "arn:aws:logs:us-west-2:123456789012:log-group:vpc-flow-logs"

  general_tags = {
    Environment = "production"
    Project     = "webapp"
  }
}
```

## Input Variables

### Core Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpc | Controls if VPC should be created | `bool` | `true` | no |
| existing_vpc_id | ID of existing VPC to use when create_vpc is false | `string` | `null` | no |
| vpc_config | VPC configuration | `list(object)` | `[]` | yes |
| general_tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

### Component Control Flags

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_subnets | Controls if subnets should be created | `bool` | `true` |
| create_internet_gateway | Controls if Internet Gateway should be created | `bool` | `true` |
| create_nat_gateway | Controls if NAT Gateway should be created | `bool` | `false` |
| create_public_route_table | Controls if public route table should be created | `bool` | `true` |
| create_private_route_table | Controls if private route tables should be created | `bool` | `true` |
| create_route_table_associations | Controls if route table associations should be created | `bool` | `true` |
| create_security_groups | Controls if security groups should be created | `bool` | `false` |
| create_network_acl | Controls if Network ACLs should be created | `bool` | `false` |
| enable_flow_logs | Controls if VPC Flow Logs should be enabled | `bool` | `false` |

### Subnet Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| public_subnets | List of public subnet configurations | `list(object)` | `[]` |
| private_subnets | List of private subnet configurations | `list(object)` | `[]` |

### NAT Gateway Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| enable_public_nat_gateway | Should be true if you want to provision public NAT Gateways | `bool` | `false` |
| enable_private_nat_gateway | Should be true if you want to provision private NAT Gateways | `bool` | `false` |
| single_public_nat_gateway | Should be true to provision a single shared NAT Gateway | `bool` | `false` |
| single_private_nat_gateway | Should be true to provision a single shared private NAT Gateway | `bool` | `false` |

## Outputs

### VPC Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_ipv6_cidr_block | The IPv6 CIDR block of the VPC |

### Subnet Outputs

| Name | Description |
|------|-------------|
| public_subnets | List of IDs of public subnets |
| private_subnets | List of IDs of private subnets |
| public_subnet_arns | List of ARNs of public subnets |
| private_subnet_arns | List of ARNs of private subnets |

### Gateway Outputs

| Name | Description |
|------|-------------|
| internet_gateway_id | The ID of the Internet Gateway |
| public_nat_gateway_ids | List of IDs of the public NAT Gateways |
| private_nat_gateway_ids | List of IDs of the private NAT Gateways |

### Route Table Outputs

| Name | Description |
|------|-------------|
| public_route_table_id | ID of the public route table |
| private_route_table_ids | List of IDs of the private route tables |

## Architecture

This module creates a typical AWS VPC architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                        VPC (10.0.0.0/16)                   │
│                                                             │
│  ┌─────────────────────┐    ┌─────────────────────┐        │
│  │   Public Subnet     │    │   Public Subnet     │        │
│  │   10.0.1.0/24       │    │   10.0.2.0/24       │        │
│  │   (us-west-2a)      │    │   (us-west-2b)      │        │
│  │                     │    │                     │        │
│  │  ┌─────────────┐    │    │                     │        │
│  │  │ NAT Gateway │    │    │                     │        │
│  │  └─────────────┘    │    │                     │        │
│  └─────────────────────┘    └─────────────────────┘        │
│                                                             │
│  ┌─────────────────────┐    ┌─────────────────────┐        │
│  │  Private Subnet     │    │  Private Subnet     │        │
│  │  10.0.10.0/24       │    │  10.0.20.0/24       │        │
│  │  (us-west-2a)       │    │  (us-west-2b)       │        │
│  └─────────────────────┘    └─────────────────────┘        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────────────┐
                    │ Internet Gateway│
                    └─────────────────┘
                              │
                          Internet
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## License

This module is released under the MIT License.