# AWS Default Route Table Terraform Module - Simplified VPC Route Management

This Terraform module provides a streamlined way to manage the default route table in AWS VPCs. It offers comprehensive control over route configurations, including support for IPv4/IPv6 routing, multiple gateway types (Internet, NAT, Transit), and VPC peering connections, all while maintaining AWS best practices for network architecture.

The module simplifies the complex task of managing VPC routing by providing a declarative approach to route table configuration. It supports various routing scenarios including internet access, VPC peering, transit gateway connections, and NAT gateway routing. The module is particularly useful for organizations that need to maintain consistent routing configurations across multiple VPCs or require flexible routing patterns for different network architectures.

## Repository Structure
```
modules/aws_default_route_table/
├── main.tf           # Core resource definitions for AWS default route table management
├── variables.tf      # Input variable definitions for module configuration
├── outputs.tf        # Output definitions for route table ID and ARN
└── versions.tf       # Terraform and provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- Existing VPC infrastructure (if managing existing route tables)

### Installation

1. Add the module to your Terraform configuration:

```hcl
module "default_route_table" {
  source = "path/to/modules/aws_default_route_table"

  create_vpc                = true
  manage_default_route_table = true
  default_route_table_id    = "rtb-xxxxx"
  
  # Route propagation configuration
  default_route_table_propagating_vgws = []
  
  # Route configurations
  default_route_table_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = "igw-xxxxx"
    }
  ]

  # Tags
  default_route_table_tags = {
    Environment = "production"
  }
  general_tags = {
    Project = "network-infrastructure"
  }
}
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the planned changes:
```bash
terraform plan
```

4. Apply the configuration:
```bash
terraform get
terraform apply
```

### Quick Start
1. Basic VPC route table with internet access:
```hcl
module "default_route_table" {
  source = "path/to/modules/aws_default_route_table"

  create_vpc = true
  manage_default_route_table = true
  default_route_table_id = "rtb-xxxxx"
  
  default_route_table_routes = [
    {
      cidr_block = "0.0.0.0/0"
      internal_igw = true
    }
  ]

  create_igw = true
  public_subnets_length = 1
}
```

### More Detailed Examples

1. Route table with NAT Gateway configuration:
```hcl
module "default_route_table" {
  source = "path/to/modules/aws_default_route_table"

  create_vpc = true
  manage_default_route_table = true
  default_route_table_id = "rtb-xxxxx"
  
  default_route_table_routes = [
    {
      cidr_block = "0.0.0.0/0"
      internal_public_nat_gateway = true
    }
  ]

  enable_public_nat_gateway = true
}
```

2. IPv6 support with egress-only gateway:
```hcl
module "default_route_table" {
  source = "path/to/modules/aws_default_route_table"

  create_vpc = true
  manage_default_route_table = true
  default_route_table_id = "rtb-xxxxx"
  enable_ipv6 = true
  
  default_route_table_routes = [
    {
      ipv6_cidr_block = "::/0"
      internal_egress_only_igw = true
    }
  ]

  create_egress_only_igw = true
}
```

### Troubleshooting

Common issues and solutions:

1. Route Table Not Found
```
Error: Reference to undeclared resource
```
- Verify the `default_route_table_id` exists
- Ensure AWS credentials have sufficient permissions
- Check if the VPC exists and is accessible

2. Route Creation Failures
```
Error: Error creating route
```
- Verify target resources (IGW, NAT Gateway, etc.) exist
- Check CIDR block conflicts
- Ensure route targets are in the correct state

Debug Mode:
- Enable Terraform logging:
```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
```

## Data Flow
The module manages route table configurations by transforming input variables into AWS route table resources.

```ascii
Input Variables    Route Table Resource    AWS Infrastructure
     │                    │                       │
     ▼                    ▼                       ▼
[Configuration] ──► [Route Processing] ──► [Default Route Table]
     │                    │                       │
     └──► [Tags] ────────┴─► [Resource Tags] ────┘
```

Key component interactions:
1. Module accepts route configurations through variables
2. Routes are processed through dynamic blocks
3. Gateway references are resolved (IGW, NAT, Transit)
4. Route propagation is configured if specified
5. Tags are applied to the route table resource
6. AWS API creates/updates the route table configuration
7. Resource IDs and ARNs are exported as outputs