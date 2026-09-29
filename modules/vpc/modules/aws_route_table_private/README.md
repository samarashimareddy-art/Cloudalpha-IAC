# AWS Private Route Table Terraform Module - Simplify VPC Network Routing Management

This Terraform module creates and manages private route tables in AWS VPC with support for multiple routing configurations and gateway integrations. It provides a flexible and maintainable way to define private network routing with support for IPv4/IPv6, NAT gateways, transit gateways, and VPC peering connections.

The module offers comprehensive routing capabilities including:
- Multiple private route table creation with custom naming
- Support for various destination types (CIDR blocks, IPv6, prefix lists)
- Integration with AWS gateways (Internet, NAT, Transit)
- VPC peering and endpoint routing
- Route propagation via virtual gateways
- IPv4 and IPv6 support
- Customizable tags and timeouts

## Repository Structure
```
modules/aws_route_table_private/
├── main.tf           # Core resource definitions for route tables and routing configuration
├── variables.tf      # Input variable definitions including route table configurations
├── outputs.tf        # Output definitions for route table IDs, ARNs, and names
└── versions.tf       # Terraform and provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- Existing VPC infrastructure
- IAM permissions for route table management

### Installation

1. Add the module to your Terraform configuration:
```hcl
module "private_route_tables" {
  source = "path/to/modules/aws_route_table_private"

  vpc_id                = "vpc-1234567890"
  create_vpc            = true
  private_subnets       = ["subnet-1", "subnet-2"]
  private_subnets_length = 2
  public_subnets_length = 1

  private_route_tables = [
    {
      name = "private-rt-1"
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          internal_public_nat_gateway = true
        }
      ]
    }
  ]

  general_tags = {
    Environment = "Production"
    Terraform   = "true"
  }
}
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the plan:
```bash
terraform plan
```

4. Apply the configuration:
```bash
terraform apply
```

### Quick Start
1. Create a basic private route table with NAT gateway:
```hcl
module "simple_private_route_table" {
  source = "path/to/modules/aws_route_table_private"

  vpc_id                    = var.vpc_id
  create_vpc               = true
  enable_public_nat_gateway = true
  private_subnets          = var.private_subnet_ids
  private_subnets_length   = length(var.private_subnet_ids)
  public_subnets_length    = length(var.public_subnet_ids)

  private_route_tables = [
    {
      name = "private-rt"
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          internal_public_nat_gateway = true
        }
      ]
    }
  ]
}
```

### More Detailed Examples

1. Private route table with IPv6 support and egress-only gateway:
```hcl
module "ipv6_private_route_table" {
  source = "path/to/modules/aws_route_table_private"

  vpc_id                 = var.vpc_id
  create_vpc            = true
  enable_ipv6          = true
  create_egress_only_igw = true

  private_route_tables = [
    {
      name = "ipv6-private-rt"
      routes = [
        {
          ipv6_cidr_block = "::/0"
          internal_egress_only_igw = true
        }
      ]
    }
  ]
}
```

### Troubleshooting

Common issues and solutions:

1. Route Table Creation Failure
```
Error: Error creating route table: UnauthorizedOperation
```
Solution: Ensure IAM permissions include:
- ec2:CreateRouteTable
- ec2:CreateRoute
- ec2:CreateTags

2. NAT Gateway Association Issues
```
Error: Reference to undeclared resource
```
Solution: Verify that:
- NAT Gateway creation is enabled (`enable_public_nat_gateway = true`)
- Public subnets exist (`public_subnets_length > 0`)
- VPC creation is enabled (`create_vpc = true`)

## Data Flow
The module manages route table creation and route configuration in AWS VPC networking. It processes input variables to create route tables and configure routing rules for private subnets.

```ascii
Input Variables
      ↓
[Route Table Configuration]
      ↓
[AWS Route Table Resource]
      ↓
[Route Entries] → [Gateway Associations]
      ↓
Output (IDs, ARNs, Names)
```

Component interactions:
1. Module receives route table configurations through variables
2. Creates route table resources in specified VPC
3. Configures routes based on provided route configurations
4. Associates routes with appropriate gateways (NAT, Internet, Transit)
5. Applies tags and propagation settings
6. Exposes route table identifiers through outputs
7. Manages timeouts for creation and updates