# AWS VPC Security Groups Terraform Module - Simplified Security Group Management with Flexible Rule Configuration

This Terraform module provides a streamlined way to create and manage AWS Security Groups with configurable ingress and egress rules. 
It simplifies the process of setting up security groups by offering a structured approach to defining rules while maintaining flexibility through variable configurations.

The module supports comprehensive security group management with features including:
- Dynamic creation of ingress and egress rules with support for IPv4/IPv6 CIDR blocks and prefix lists
- Customizable timeout settings for security group deletion
- Flexible tagging system for resource organization
- Support for both TCP/UDP port ranges and ICMP protocols
- Built-in lifecycle management with create-before-destroy capability

## Repository Structure
```
modules/aws_vpc_security_groups/
├── main.tf           # Core security group and rule definitions
├── variables.tf      # Input variable declarations for module configuration
├── outputs.tf        # Exposes security group ID and ARN
└── versions.tf       # Terraform and AWS provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- VPC already created in the target AWS account

### Installation

1. Add the module to your Terraform configuration:

```hcl
module "security_groups" {
  source = "path/to/modules/aws_vpc_security_groups"

  name        = "example-security-group"
  description = "Example security group"
  vpc_id      = "vpc-xxxxxxxx"
  tags        = {
    Environment = "production"
  }

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]

  enable_custom_timeout = false
  timeout_delete       = "45m"
}
```

2. Initialize Terraform:
```bash
terraform init
```

3. Apply the configuration:
```bash
terraform plan
terraform apply
```

### Quick Start

1. Create a basic security group with HTTP access:
```hcl
module "web_security_group" {
  source = "path/to/modules/aws_vpc_security_groups"

  name        = "web-sg"
  description = "Web server security group"
  vpc_id      = "vpc-xxxxxxxx"
  tags        = {
    Name = "web-sg"
  }

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP access"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]

  egress_rules = []
  enable_custom_timeout = false
  timeout_delete       = "45m"
}
```

### More Detailed Examples

1. Security group with multiple ingress rules:
```hcl
module "app_security_group" {
  source = "path/to/modules/aws_vpc_security_groups"

  name        = "app-sg"
  description = "Application security group"
  vpc_id      = "vpc-xxxxxxxx"
  tags        = {
    Name = "app-sg"
    Environment = "production"
  }

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP access"
      cidr_ipv4   = "10.0.0.0/8"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS access"
      cidr_ipv4   = "10.0.0.0/8"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access"
      cidr_ipv6   = "::/0"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound"
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]

  enable_custom_timeout = true
  timeout_delete       = "30m"
}
```

### Troubleshooting

Common issues and solutions:

1. Security Group Deletion Timeout
- Problem: Security group deletion fails with timeout error
- Solution: Enable custom timeout and increase the duration
```hcl
enable_custom_timeout = true
timeout_delete       = "60m"
```

2. Rule Creation Failures
- Problem: "InvalidParameterValue" when creating rules
- Solution: Verify CIDR blocks are in correct format and port ranges are valid
- Debug: Enable Terraform debug logging
```bash
export TF_LOG=DEBUG
terraform apply
```

## Data Flow
The module creates a security group and associated rules in AWS VPC. It processes input variables to configure the security group and its rules, then outputs the security group ID and ARN for reference.

```ascii
Input Variables    Security Group     Rules
     │                  │              │
     ▼                  ▼              ▼
[Configuration] → [AWS SG Create] → [Ingress/Egress Rules]
                       │
                       ▼
                  [Outputs: ID/ARN]
```

Component interactions:
1. Module accepts configuration through variables
2. Creates security group in specified VPC
3. Processes ingress rules list and creates individual rules
4. Processes egress rules list and creates individual rules
5. Applies tags to the security group
6. Manages lifecycle with create_before_destroy
7. Handles custom deletion timeouts if enabled
8. Exposes security group ID and ARN as outputs