# AWS VPC Endpoint Service Terraform Module

This Terraform module creates and manages AWS VPC Endpoint Services with support for both Network Load Balancer and Gateway Load Balancer endpoints. It provides a flexible way to expose your services to other AWS accounts while maintaining control over access through principal authorization.

The module supports creating multiple VPC endpoint services with customizable configurations including acceptance requirements, load balancer associations, private DNS names, and IP address types. It also manages access control by allowing you to specify which AWS principals (accounts, users, or roles) can create endpoints to connect to your service.

## Repository Structure
```
modules/vpc_endpoint_service/
├── main.tf                 # Core resource definitions for VPC endpoint services and principal access
├── outputs.tf             # Defines output values for endpoint service and principal IDs
├── variables.tf           # Input variable definitions for service configuration
└── versions.tf           # Terraform and provider version constraints
```

## Usage Instructions

### Prerequisites
- Terraform >= 1.5.7
- AWS Provider >= 5.94.1
- AWS CLI configured with appropriate credentials
- Existing Network Load Balancer(s) or Gateway Load Balancer(s) in your VPC

### Installation

1. Add the module to your Terraform configuration:

```hcl
module "vpc_endpoint_service" {
  source = "path/to/modules/vpc_endpoint_service"

  endpoint_services = {
    "service-1" = {
      acceptance_required         = true
      network_load_balancer_arns = ["arn:aws:elasticloadbalancing:region:account:loadbalancer/net/name/id"]
      private_dns_name           = "service.example.com"
    }
  }

  allowed_principals = {
    "account-1" = {
      vpc_endpoint_service_id = module.vpc_endpoint_service.vpc_endpoint_service_ids["service-1"]
      principal_arn          = "arn:aws:iam::123456789012:root"
    }
  }

  service_tags = {
    Environment = "production"
    Managed_by  = "terraform"
  }
}
```

### Quick Start

1. Create a new Terraform configuration file (e.g., `main.tf`)
2. Copy the module usage example above
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

1. Creating a VPC Endpoint Service with multiple load balancers:
```hcl
module "vpc_endpoint_service" {
  source = "path/to/modules/vpc_endpoint_service"

  endpoint_services = {
    "multi-lb-service" = {
      acceptance_required         = true
      network_load_balancer_arns = [
        "arn:aws:elasticloadbalancing:region:account:loadbalancer/net/nlb1/id1",
        "arn:aws:elasticloadbalancing:region:account:loadbalancer/net/nlb2/id2"
      ]
      supported_ip_address_types = ["ipv4"]
      supported_regions         = ["us-east-1", "us-west-2"]
    }
  }

  service_tags = {
    Service = "endpoint-service"
  }
}
```

2. Configuring multiple allowed principals:
```hcl
module "vpc_endpoint_service" {
  # ... endpoint_services configuration ...

  allowed_principals = {
    "account-1" = {
      vpc_endpoint_service_id = module.vpc_endpoint_service.vpc_endpoint_service_ids["service-1"]
      principal_arn          = "arn:aws:iam::111111111111:root"
    }
    "account-2" = {
      vpc_endpoint_service_id = module.vpc_endpoint_service.vpc_endpoint_service_ids["service-1"]
      principal_arn          = "arn:aws:iam::222222222222:root"
    }
  }
}
```

### Troubleshooting

Common issues and solutions:

1. **Load Balancer Not Found**
   - Error: `Error creating VPC Endpoint Service: LoadBalancerNotFound`
   - Solution: Verify that the provided load balancer ARNs exist and are in the correct region

2. **Invalid Principal ARN**
   - Error: `Error adding principal: InvalidPrincipal`
   - Solution: Ensure the principal ARN is correctly formatted and exists

3. **Private DNS Name Validation**
   - Error: `InvalidPrivateDnsName`
   - Solution: Ensure the private DNS name follows AWS naming conventions and you own the domain

## Data Flow
The module manages the creation of VPC Endpoint Services and their associated principal permissions. It takes configuration input through variables and creates the necessary AWS resources.

```ascii
Input Variables                AWS Resources
     │                              │
     ▼                              ▼
[endpoint_services] ──────► [VPC Endpoint Service]
     │                              │
     ▼                              ▼
[allowed_principals] ──────► [Allowed Principals]
     │                              │
     ▼                              ▼
[service_tags] ──────────► [Resource Tags]
```

Key component interactions:
1. VPC Endpoint Service creation using provided configuration
2. Association with specified Network or Gateway Load Balancers
3. Principal authorization management
4. Tag application to resources
5. Output generation for resource IDs