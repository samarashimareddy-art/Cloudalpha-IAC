# AWS VPC Core Module - Flexible Virtual Private Cloud Infrastructure Management

This Terraform module provides a robust and flexible way to create and manage AWS Virtual Private Cloud (VPC) resources. It enables the creation of multiple VPCs with support for both IPv4 and IPv6 addressing, IPAM pool integration, and secondary CIDR block association, making it ideal for complex network architectures and multi-tenant environments.

The module offers comprehensive configuration options including DNS settings, instance tenancy, and CIDR block management. It supports both standard CIDR block allocation and AWS's IPAM (IP Address Manager) for more sophisticated IP address management. The module also provides extensive tagging capabilities and outputs essential VPC information for use in other Terraform configurations.

## Repository Structure
```
modules/
└── vpc_core/
    ├── main.tf         # Core VPC resource definitions and CIDR block associations
    ├── outputs.tf      # Defines VPC output variables (IDs, ARNs, CIDR blocks)
    ├── variables.tf    # Input variable definitions for VPC configuration
    └── versions.tf     # Terraform and provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- IAM permissions to create and manage VPC resources

### Installation
1. Add the module to your Terraform configuration:
```hcl
module "vpc" {
  source = "path/to/modules/vpc_core"
  
  create_vpc = true
  vpc = [
    {
      name                 = "my-vpc"
      ipv4_cidr           = "10.0.0.0/16"
      enable_dns_hostnames = true
      enable_dns_support   = true
    }
  ]
}
```

2. Initialize Terraform:
```bash
terraform init
```

### Quick Start
1. Create a basic VPC:
```hcl
module "vpc" {
  source = "path/to/modules/vpc_core"
  
  vpc = [
    {
      name       = "simple-vpc"
      ipv4_cidr  = "172.16.0.0/16"
    }
  ]
}
```

2. Apply the configuration:
```bash
terraform plan
terraform apply
```

### More Detailed Examples
1. Creating a VPC with IPv6 support:
```hcl
module "vpc" {
  source = "path/to/modules/vpc_core"
  
  vpc = [
    {
      name                              = "ipv6-vpc"
      ipv4_cidr                        = "10.0.0.0/16"
      enable_ipv6                      = true
      amazon_provided_ipv6_cidr_block  = true
    }
  ]
}
```

2. VPC with secondary CIDR blocks:
```hcl
module "vpc" {
  source = "path/to/modules/vpc_core"
  
  vpc = [
    {
      name       = "expanded-vpc"
      ipv4_cidr  = "10.0.0.0/16"
    }
  ]
  
  secondary_cidr_blocks = ["172.16.0.0/16", "192.168.0.0/16"]
}
```

### Troubleshooting
Common issues and solutions:

1. CIDR Block Conflicts
```
Error: The CIDR block is already in use
```
- Verify that the CIDR blocks don't overlap with existing VPCs
- Check AWS VPC limits in the region
- Use `aws ec2 describe-vpcs` to list existing VPCs and their CIDR blocks

2. IPv6 Configuration Issues
```
Error: Error creating VPC: InvalidParameter
```
- Ensure `enable_ipv6` is set to true when using IPv6-related configurations
- Verify IPAM pool IDs are correct if using IPAM
- Check regional IPv6 support

### Terragrunt Deployment
1. Create a terragrunt.hcl file in your environment directory:
```hcl
 include "root" {
   path = find_in_parent_folders()
 }

 terraform {
   source = "../../modules/vpc_core"
 }

 inputs = {
   create_vpc = true
   vpc = [
     {
       name                 = "terragrunt-vpc"
       ipv4_cidr           = "10.0.0.0/16"
       enable_dns_hostnames = true
       enable_dns_support   = true
     }
   ]

   general_tags = {
     Environment = "dev"
     Terraform   = "true"
   }
 }
```

2. Deploy using Terragrunt commands:
```bash
 # Initialize Terragrunt
 terragrunt init

 # Plan the deployment
 terragrunt plan

 # Apply the configuration
 terragrunt apply
```

## Data Flow
The module processes VPC configurations through a series of resource creation steps, handling both primary and secondary CIDR blocks, and managing IPv4 and IPv6 addressing schemes.

```ascii
Input Variables    Resource Creation    Output
     │                   │                │
     ▼                   ▼                ▼
[VPC Config] ──► [AWS VPC Resource] ──► [VPC IDs]
     │                   │                │
     └──► [Secondary ──► [CIDR Block] ──► [CIDR Info]
          CIDR Config]   Association
```

Key component interactions:
- VPC resource creation is controlled by the `create_vpc` variable
- CIDR blocks are allocated based on provided configurations or IPAM pools
- IPv6 addressing is managed through AWS-provided or custom CIDR blocks
- Secondary CIDR blocks are associated after primary VPC creation
- All resources are tagged according to the provided tagging strategy