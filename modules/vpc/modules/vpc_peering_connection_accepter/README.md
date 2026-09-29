# AWS VPC Peering Connection Accepter Terraform Module

This Terraform module manages VPC peering connection accepters in AWS, enabling secure communication between VPCs. It provides automated acceptance of VPC peering connections and configuration of DNS resolution options between the peered VPCs.

The module supports managing multiple VPC peering connections simultaneously through map variables, allowing for flexible configuration of peering relationships. It handles both the acceptance of peering connections and the configuration of peering options, including DNS resolution settings for both the accepter and requester VPCs.

## Repository Structure
```
modules/vpc_peering_connection_accepter/
├── main.tf                 # Core resource definitions for VPC peering accepter and options
├── outputs.tf             # Output definitions for peering connection IDs
├── variables.tf           # Input variable definitions for module configuration
└── versions.tf           # Terraform and provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS credentials configured with appropriate permissions
- Existing VPC peering connection requests to accept

### Installation

1. Include the module in your Terraform configuration:
```hcl
module "vpc_peering_accepter" {
  source = "path/to/modules/vpc_peering_connection_accepter"

  peering_connection_accepters = {
    "peering1" = {
      vpc_peering_connection_id = "pcx-12345678"
      auto_accept = true
      accepter_allow_remote_vpc_dns_resolution = true
      requester_allow_remote_vpc_dns_resolution = true
    }
  }

  peering_connection_options = {
    "peering1" = {
      vpc_peering_connection_id = "pcx-12345678"
      accepter_allow_remote_vpc_dns_resolution = true
      requester_allow_remote_vpc_dns_resolution = true
    }
  }

  accepter_tags = {
    Environment = "Production"
    Managed_by = "Terraform"
  }
}
```

### Quick Start

1. Create a new Terraform configuration file with the module declaration
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

1. Accept multiple peering connections:
```hcl
module "vpc_peering_accepter" {
  source = "path/to/modules/vpc_peering_connection_accepter"

  peering_connection_accepters = {
    "prod-to-dev" = {
      vpc_peering_connection_id = "pcx-12345678"
      auto_accept = true
    }
    "prod-to-staging" = {
      vpc_peering_connection_id = "pcx-87654321"
      auto_accept = true
      accepter_allow_remote_vpc_dns_resolution = true
    }
  }

  accepter_tags = {
    Environment = "Production"
    Purpose = "Cross-environment-communication"
  }
}
```

### Troubleshooting

Common issues and solutions:

1. Peering Connection Not Found
   - Error: `Error: VPC Peering Connection not found`
   - Solution: Verify the `vpc_peering_connection_id` exists and is in a pending acceptance state
   - Check AWS Console > VPC > Peering Connections

2. Permission Issues
   - Error: `Error: User is not authorized to perform: ec2:AcceptVpcPeeringConnection`
   - Solution: Ensure AWS credentials have the following permissions:
     * ec2:AcceptVpcPeeringConnection
     * ec2:ModifyVpcPeeringConnectionOptions
   - Verify IAM role/policy configuration

## Data Flow
The module manages the acceptance and configuration of VPC peering connections by interacting with AWS EC2 API endpoints to establish and configure VPC peering relationships.

```ascii
Terraform Configuration
       │
       ▼
AWS Provider API
       │
       ├─────────────────────┐
       │                     │
       ▼                     ▼
VPC Peering Accepter    VPC Peering Options
(auto-accept)          (DNS resolution)
       │                     │
       └──────────┬─────────┘
                  │
                  ▼
        Active VPC Peering
        Connection
```

Component interactions:
1. Module accepts incoming VPC peering connection requests
2. Configures DNS resolution settings for both VPCs
3. Applies tags to the peering connection
4. Manages multiple peering connections through map variables
5. Outputs connection IDs for reference by other resources