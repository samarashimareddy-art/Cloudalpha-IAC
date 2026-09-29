# AWS Internet Gateway Terraform Module - Simplified VPC Internet Connectivity

This Terraform module provides a streamlined way to create and manage AWS Internet Gateways (IGW) for your VPC infrastructure. It enables internet connectivity for resources in public subnets while offering flexible configuration options and consistent tagging capabilities.

The module implements AWS best practices for Internet Gateway deployment with conditional creation based on VPC and subnet configurations. It supports comprehensive tagging for resource management and provides essential outputs for integration with other infrastructure components.

## Repository Structure
```
modules/aws_internet_gateway/
├── main.tf           # Core IGW resource definition and creation logic
├── variables.tf      # Input variable definitions for module configuration
├── outputs.tf        # Exposes IGW ID and ARN for external reference
└── versions.tf       # Terraform and provider version constraints
```

## Usage Instructions

### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS account with appropriate permissions
- Existing VPC with public subnets

### Installation

1. Reference the module in your Terraform configuration:

```hcl
module "internet_gateway" {
  source = "path/to/modules/aws_internet_gateway"

  create_vpc      = true
  create_igw     = true
  vpc_id         = "vpc-12345678"
  public_subnets = ["subnet-12345678", "subnet-87654321"]
  
  igw_tags = {
    Environment = "Production"
  }
  
  general_tags = {
    Project     = "MyProject"
    Terraform   = "true"
  }
}
```

### Quick Start

1. Create a new Terraform configuration file (e.g., `main.tf`)
2. Add the module block as shown in the installation section
3. Initialize Terraform:
```bash
terraform init
```
4. Review the planned changes:
```bash
terraform plan
```
5. Apply the configuration:
```bash
terraform apply
```

### More Detailed Examples

Creating an IGW with custom tags:
```hcl
module "internet_gateway" {
  source = "path/to/modules/aws_internet_gateway"

  create_vpc      = true
  create_igw     = true
  vpc_id         = aws_vpc.main.id
  public_subnets = aws_subnet.public[*].id
  
  igw_tags = {
    Environment = "Production"
    Service     = "Web"
  }
  
  general_tags = {
    Project     = "E-commerce"
    Terraform   = "true"
    Owner       = "Infrastructure Team"
  }
}
```

### Troubleshooting

Common issues and solutions:

1. IGW not being created
   - Verify that `create_vpc` and `create_igw` are set to `true`
   - Ensure `public_subnets` list is not empty
   - Check if the specified `vpc_id` exists

2. Tag conflicts
   - Review `igw_tags` and `general_tags` for duplicates
   - Ensure tag values meet AWS requirements

Debug mode can be enabled by setting the following environment variable:
```bash
export TF_LOG=DEBUG
```

Log files location: 
- Linux/MacOS: `$HOME/.terraform.d/log/`
- Windows: `%APPDATA%/terraform.d/log/`

## Data Flow

The module evaluates input variables and conditions to create an Internet Gateway attached to the specified VPC.

```ascii
Input Variables ──► Conditional Logic ──► IGW Creation ──► VPC Attachment
     │                    │                    │                │
     └─ VPC ID           └─ create_vpc        └─ AWS IGW      └─ Output
     └─ Subnet IDs       └─ create_igw           Resource        Variables
     └─ Tags            └─ public_subnets
```

Component interactions:
1. Module receives input variables including VPC ID and subnet information
2. Conditional logic evaluates creation criteria
3. IGW resource is created if all conditions are met
4. IGW attaches to specified VPC
5. Tags are applied from both specific and general tag maps
6. Module outputs IGW ID and ARN for reference
7. Route tables must be configured separately to use the IGW