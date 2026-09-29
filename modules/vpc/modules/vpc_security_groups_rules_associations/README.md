# AWS VPC Security Groups Rules and Associations Terraform Module

This Terraform module manages AWS VPC security group rules and associations, providing a flexible and maintainable way to define ingress rules, egress rules, and VPC associations. The module supports comprehensive security group configuration with IPv4/IPv6 CIDR blocks, port ranges, and cross-reference between security groups.

The module implements AWS best practices for network security by allowing granular control over inbound and outbound traffic rules. It supports both standalone CIDR-based rules and referenced security group rules, making it suitable for complex networking scenarios in AWS environments. The module also provides consistent tagging capabilities across all created resources.

## Repository Structure
```
modules/vpc_security_groups_rules_associations/
├── main.tf           # Core resource definitions for security group rules and VPC associations
├── outputs.tf        # Defines output values for rule and association IDs
├── variables.tf      # Input variable definitions for rules and associations configuration
└── versions.tf       # Terraform and provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS credentials configured with appropriate permissions
- Existing VPC and Security Groups in your AWS account

### Installation

1. Add the module to your Terraform configuration:

```hcl
module "security_groups_rules" {
  source = "path/to/modules/vpc_security_groups_rules_associations"

  egress_rules = {
    allow_all = {
      security_group_id = "sg-123456789"
      ip_protocol      = "-1"
      cidr_ipv4       = "0.0.0.0/0"
      description     = "Allow all outbound traffic"
    }
  }

  ingress_rules = {
    allow_https = {
      security_group_id = "sg-123456789"
      ip_protocol      = "tcp"
      from_port       = 443
      to_port         = 443
      cidr_ipv4       = "10.0.0.0/8"
      description     = "Allow HTTPS inbound traffic"
    }
  }

  sg_vpc_associations = {
    main_vpc = {
      security_group_id = "sg-123456789"
      vpc_id           = "vpc-123456789"
    }
  }

  default_tags = {
    Environment = "Production"
    Terraform   = "true"
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
terraform apply
```

### More Detailed Examples

1. Creating multiple ingress rules:
```hcl
ingress_rules = {
  allow_http = {
    security_group_id = "sg-123456789"
    ip_protocol      = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_ipv4        = "0.0.0.0/0"
    description      = "Allow HTTP"
  }
  allow_https = {
    security_group_id = "sg-123456789"
    ip_protocol      = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_ipv4        = "0.0.0.0/0"
    description      = "Allow HTTPS"
  }
}
```

2. Reference another security group:
```hcl
ingress_rules = {
  allow_internal = {
    security_group_id            = "sg-123456789"
    ip_protocol                 = "tcp"
    from_port                   = 3306
    to_port                     = 3306
    referenced_security_group_id = "sg-987654321"
    description                 = "Allow MySQL from specific security group"
  }
}
```

### Troubleshooting

Common issues and solutions:

1. Error: Invalid Security Group ID
```
Error: InvalidGroup.NotFound: The security group 'sg-123456789' does not exist
```
Solution:
- Verify the security group exists in the specified AWS region
- Check your AWS credentials have permission to access the security group
- Ensure the security group ID is correctly formatted

2. Error: Invalid CIDR Block
```
Error: InvalidParameterValue: Invalid CIDR block format
```
Solution:
- Verify CIDR block notation (e.g., "10.0.0.0/16")
- Ensure IPv4 CIDR blocks use the correct format
- For IPv6, use valid IPv6 CIDR notation

## Data Flow
The module manages security group rules and VPC associations by creating and maintaining AWS resources based on the provided configuration.

```ascii
Input Variables    ┌─────────────────┐    AWS Resources
  (Rules) ───────►│                 │──► Security Group
                  │ Terraform Module │    Ingress Rules
  (VPC IDs) ────►│                 │──► Security Group
                  └─────────────────┘    Egress Rules
                         │
                         └──────────────► VPC Associations
```

Key component interactions:
- Security group rules are created based on the provided ingress and egress configurations
- Rules can reference CIDR blocks or other security groups
- VPC associations link security groups to specific VPCs
- All resources are tagged according to the default_tags variable
- Changes to rules or associations trigger updates to the corresponding AWS resources
- Resource IDs are exposed through output variables for reference by other Terraform configurations