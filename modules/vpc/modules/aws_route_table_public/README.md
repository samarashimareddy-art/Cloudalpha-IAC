# AWS Public Route Table Terraform Module - Simplified VPC Routing Management

This Terraform module creates and manages public route tables in AWS VPC with support for both IPv4 and IPv6 routing. It provides a flexible and maintainable way to configure routing rules for public subnets with support for multiple destination types and targets including Internet Gateways, VPC endpoints, transit gateways, and VPC peering connections.

The module offers comprehensive routing configuration options while maintaining AWS best practices for public subnet routing. It supports various routing scenarios including internet access through IGW, IPv6 egress through Egress-Only Internet Gateway, and connectivity to other AWS services through VPC endpoints. The module includes timeout configurations and proper tagging support to ensure reliable infrastructure management.

## Repository Structure
```
modules/aws_route_table_public/
├── main.tf           # Core resource definitions for route table creation and configuration
├── outputs.tf        # Defines route table ID and ARN outputs for reference
├── variables.tf      # Input variable definitions including route configurations and tags
└── versions.tf       # Terraform and AWS provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- Existing VPC and public subnets
- Appropriate AWS IAM permissions to manage route tables

### Installation

1. Include the module in your Terraform configuration:
```hcl
module "public_route_table" {
  source = "path/to/modules/aws_route_table_public"

  create_vpc             = true
  create_igw            = true
  create_egress_only_igw = false
  enable_ipv6           = false
  vpc_id               = "vpc-12345678"
  public_subnets       = ["subnet-12345678", "subnet-87654321"]

  public_route_table_routes = {
    internet_gateway = {
      cidr_block   = "0.0.0.0/0"
      internal_igw = true
    }
  }

  public_route_table_tags = {
    Environment = "Production"
  }

  general_tags = {
    Project = "MyProject"
  }
}
```

### Quick Start

1. Create a basic public route table with internet access:
```hcl
module "basic_public_route_table" {
  source = "path/to/modules/aws_route_table_public"

  create_vpc     = true
  create_igw    = true
  vpc_id       = "vpc-12345678"
  public_subnets = ["subnet-12345678"]

  public_route_table_routes = {
    internet_access = {
      cidr_block   = "0.0.0.0/0"
      internal_igw = true
    }
  }

  public_route_table_tags = {}
  general_tags = {}
}
```

### More Detailed Examples

1. Configure IPv6 routing with Egress-Only Internet Gateway:
```hcl
module "ipv6_public_route_table" {
  source = "path/to/modules/aws_route_table_public"

  create_vpc             = true
  create_igw            = true
  create_egress_only_igw = true
  enable_ipv6           = true
  vpc_id               = "vpc-12345678"
  public_subnets       = ["subnet-12345678"]

  public_route_table_routes = {
    ipv4_internet = {
      cidr_block   = "0.0.0.0/0"
      internal_igw = true
    }
    ipv6_egress = {
      ipv6_cidr_block        = "::/0"
      internal_egress_only_igw = true
    }
  }

  public_route_table_tags = {
    IPv6_Enabled = "true"
  }
}
```

### Troubleshooting

Common issues and solutions:

1. Route Table Not Created
   - Error: "No route table was created"
   - Check if `create_vpc` is set to true and `public_subnets` contains at least one subnet
   - Verify VPC ID exists and is valid

2. Internet Gateway Route Issues
   - Error: "Error creating route: InvalidGatewayID.NotFound"
   - Ensure `create_igw` is set to true when using `internal_igw = true`
   - Verify IGW creation permissions in IAM role

3. IPv6 Configuration Problems
   - Error: "InvalidIPv6CidrBlock"
   - Confirm `enable_ipv6` is set to true
   - Verify VPC has IPv6 CIDR block assigned

## Data Flow
The module processes route table configuration through a series of resource creation and association steps. It evaluates input variables to determine resource creation and configures routes based on the provided specifications.

```ascii
Input Variables ──> Route Table Creation ──> Route Configuration ──> Route Table Association
     │                     │                         │                         │
     │                     │                         │                         │
     └─► create_vpc       └─► aws_route_table      └─► dynamic routes      └─► Output
         create_igw           resource                  configuration           route table
         vpc_id                                                               ID and ARN
```

Key component interactions:
1. Module validates creation flags and subnet existence
2. Creates route table resource in specified VPC
3. Processes route configurations through dynamic blocks
4. Applies specified tags to the route table
5. Configures timeouts for resource creation and updates
6. Handles both IPv4 and IPv6 routing configurations
7. Manages multiple target types for routes (IGW, EIGW, VPC endpoints, etc.)