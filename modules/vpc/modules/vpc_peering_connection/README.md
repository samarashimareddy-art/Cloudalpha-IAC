# AWS VPC Peering Connection Terraform Module

This Terraform module creates and manages AWS VPC peering connections between VPCs. It provides a flexible way to establish network connectivity between Virtual Private Clouds (VPCs) in AWS, enabling direct communication between VPCs using private IP addresses.

The module supports cross-region and cross-account VPC peering with configurable DNS resolution settings. It allows you to create multiple VPC peering connections with customizable settings through a simple map-based configuration, making it ideal for complex networking setups where multiple VPCs need to communicate securely.

## Repository Structure
```
modules/vpc_peering_connection/
├── main.tf           # Core resource definitions for VPC peering connections
├── outputs.tf        # Defines output values for peering connection IDs
├── variables.tf      # Input variable definitions for peering configurations
└── versions.tf       # Terraform and provider version constraints
```

## Usage Instructions

### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- Existing VPCs that you want to peer
- Appropriate IAM permissions to create VPC peering connections

### Installation

1. Add the module to your Terraform configuration:

```hcl
module "vpc_peering" {
  source = "path/to/modules/vpc_peering_connection"

  peering_connections = {
    "peering1" = {
      peer_vpc_id = "vpc-1234567890"
      vpc_id      = "vpc-0987654321"
      auto_accept = true
    }
  }

  peering_tags = {
    Environment = "Production"
    Managed_by  = "Terraform"
  }
}
```

### Quick Start

1. Create a basic VPC peering connection:

```hcl
module "vpc_peering" {
  source = "path/to/modules/vpc_peering_connection"

  peering_connections = {
    "main-to-secondary" = {
      vpc_id      = "vpc-11111111"
      peer_vpc_id = "vpc-22222222"
      auto_accept = true
    }
  }

  peering_tags = {
    Environment = "Production"
  }
}
```

2. Access the peering connection ID:

```hcl
output "peering_connection_id" {
  value = module.vpc_peering.vpc_peering_connection_ids["main-to-secondary"]
}
```

### More Detailed Examples

1. Cross-region VPC peering with DNS resolution:

```hcl
module "vpc_peering" {
  source = "path/to/modules/vpc_peering_connection"

  peering_connections = {
    "us-east-1-to-us-west-2" = {
      vpc_id                                = "vpc-11111111"
      peer_vpc_id                           = "vpc-22222222"
      peer_region                           = "us-west-2"
      auto_accept                           = false
      accepter_allow_remote_vpc_dns_resolution  = true
      requester_allow_remote_vpc_dns_resolution = true
    }
  }

  peering_tags = {
    Environment = "Production"
    Purpose     = "Cross-Region-Connection"
  }
}
```

2. Cross-account VPC peering:

```hcl
module "vpc_peering" {
  source = "path/to/modules/vpc_peering_connection"

  peering_connections = {
    "cross-account" = {
      vpc_id         = "vpc-11111111"
      peer_vpc_id    = "vpc-22222222"
      peer_owner_id  = "123456789012"
      auto_accept    = false
    }
  }

  peering_tags = {
    Environment = "Production"
    Type        = "Cross-Account"
  }
}
```

### Troubleshooting

Common issues and solutions:

1. Peering Connection Stuck in "Pending Acceptance":
   - Verify that `auto_accept` is set to `true` for same-account, same-region peering
   - For cross-account peering, ensure the peer account accepts the peering request
   - Check IAM permissions in both accounts

2. DNS Resolution Not Working:
   - Confirm that both `accepter_allow_remote_vpc_dns_resolution` and `requester_allow_remote_vpc_dns_resolution` are set to `true`
   - Verify that DNS hostnames and DNS support are enabled in both VPCs

3. Route Table Configuration:
   - Remember to update route tables in both VPCs to route traffic through the peering connection
   - Use the peering connection ID from the output to configure routes

## Data Flow

The module creates VPC peering connections based on the provided configuration map. It handles the creation of peering requests and optional auto-acceptance of connections.

```ascii
Input Configuration
      ↓
[VPC A] ----Peering Request----> [VPC B]
      ↓                              ↓
DNS Resolution                 DNS Resolution
Configuration                  Configuration
      ↓                              ↓
   Tags Applied              Auto-acceptance
      ↓                        (if enabled)
Output: Peering Connection IDs
```

Key component interactions:
- VPC peering request is initiated from the requester VPC
- Auto-acceptance occurs if enabled and possible (same account, same region)
- DNS resolution settings are applied to both requester and accepter VPCs
- Tags are applied to the peering connection
- Peering connection IDs are exposed through module outputs
- Cross-region peering requires manual acceptance in the peer region
- Cross-account peering requires acceptance from the peer account owner