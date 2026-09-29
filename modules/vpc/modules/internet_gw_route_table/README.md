# AWS Internet Gateway Route Table Terraform Module

This Terraform module creates and manages an AWS Route Table specifically designed for Internet Gateway configurations. It provides a flexible and reusable way to define routing rules for VPC traffic through an Internet Gateway, supporting both IPv4 and IPv6 routing with configurable targets including network interfaces and VPC endpoints.

The module offers granular control over route table creation and configuration, with support for custom tags and multiple route definitions. It's particularly useful for organizations that need to maintain consistent routing configurations across multiple VPCs or require specific routing patterns for internet-bound traffic.

## Repository Structure
```
modules/
└── internet_gw_route_table/
    ├── main.tf           # Core resource definitions for route table creation
    ├── outputs.tf        # Defines the route table ID output
    ├── variables.tf      # Input variable definitions for module configuration
    └── versions.tf       # Terraform and provider version constraints
```

## Usage Instructions

### Prerequisites

- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- Existing VPC and Internet Gateway

### Installation

1. Add the module to your Terraform configuration:

```hcl
module "internet_gw_route_table" {
  source = "path/to/modules/internet_gw_route_table"

  create_vpc = true
  create_igw = true
  vpc_id     = "vpc-xxxxxxxx"

  internet_gw_route_table_routes = {
    route1 = {
      cidr_block         = "0.0.0.0/0"
      vpc_endpoint_id    = "vpce-xxxxxxxx"
    }
  }

  internet_gw_route_table_tags = {
    Environment = "Production"
  }

  general_tags = {
    Project = "MyProject"
    Owner   = "Infrastructure Team"
  }
}
```

### Quick Start

1. Initialize Terraform in your working directory:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform get
terraform apply
```

### More Detailed Examples

1. Creating a route table with multiple routes:
```hcl
module "internet_gw_route_table" {
  source = "path/to/modules/internet_gw_route_table"

  create_vpc = true
  create_igw = true
  vpc_id     = "vpc-xxxxxxxx"

  internet_gw_route_table_routes = {
    ipv4_route = {
      cidr_block         = "0.0.0.0/0"
      network_interface_id = "eni-xxxxxxxx"
    }
    ipv6_route = {
      ipv6_cidr_block    = "::/0"
      vpc_endpoint_id    = "vpce-xxxxxxxx"
    }
  }

  internet_gw_route_table_tags = {
    Environment = "Production"
  }

  general_tags = {
    Project = "MyProject"
  }
}
```

### Troubleshooting

Common issues and solutions:

1. Route Table Creation Failure
   - Error: "VPC not found"
   - Solution: Verify that the provided `vpc_id` exists and is accessible
   - Command to verify: `aws ec2 describe-vpcs --vpc-ids <vpc-id>`

2. Route Configuration Issues
   - Error: "Invalid route target"
   - Solution: Ensure either `network_interface_id` or `vpc_endpoint_id` is provided for each route
   - Check target resource existence using AWS CLI

3. Timeout Issues
   - Error: "timeout while waiting for route table creation"
   - Solution: Check AWS credentials and VPC service availability
   - Default timeouts are set to 5 minutes, adjust if needed

## Data Flow

The module manages the creation and configuration of route tables for internet gateway traffic in AWS VPCs. It processes input variables to create routes that direct traffic to specified targets.

```ascii
Input Variables       Route Table Resource     AWS Infrastructure
     │                       │                       │
     ▼                       ▼                       ▼
[Configuration] ──► [Route Creation] ──► [AWS Route Table]
     │                       │                       │
     └─► [Tags] ────────────┴─► [Resource Tags] ───┘
```

Component interactions:
- Module validates input variables for route table creation
- Creates route table resource in specified VPC
- Configures routes based on provided route definitions
- Applies merged tags from both specific and general tag variables
- Outputs the route table ID for reference in other resources
- Handles both IPv4 and IPv6 routing configurations
- Supports multiple route targets including network interfaces and VPC endpoints