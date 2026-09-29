# AWS VPC Flow Logs Terraform Module - Simplified Network Traffic Monitoring

This Terraform module creates and manages AWS VPC Flow Logs with flexible configuration options for monitoring network traffic across your AWS infrastructure. It provides a complete solution for capturing IP traffic information from VPCs, subnets, ENIs, and transit gateways with customizable logging destinations and formats.

The module creates the necessary IAM roles and policies automatically, supporting multiple logging destinations including CloudWatch Logs, S3 buckets, and Kinesis Data Firehose. It offers advanced features such as cross-account logging, customizable aggregation intervals, and various destination options including Hive-compatible partitioning for better data organization and analysis.

## Repository Structure
```
modules/
└── flow-logs/
    ├── main.tf           # Core resource definitions for Flow Logs, IAM roles, and policies
    ├── variables.tf      # Input variable definitions for module configuration
    ├── outputs.tf        # Output definitions exposing Flow Log ID and ARN
    └── versions.tf       # Terraform and provider version constraints
```

## Usage Instructions
### Prerequisites
- Terraform >= 1.5.2
- AWS Provider >= 5.16.1
- AWS CLI configured with appropriate credentials
- Appropriate AWS permissions to create:
  - VPC Flow Logs
  - IAM Roles and Policies
  - CloudWatch Log Groups (if using CloudWatch as destination)

### Installation
1. Add the module to your Terraform configuration:

```hcl
module "vpc_flow_logs" {
  source = "path/to/modules/flow-logs"

  traffic_type         = "ALL"
  vpc_id              = "vpc-12345678"
  log_destination_type = "cloud-watch-logs"
  log_destination     = "arn:aws:logs:region:account-id:log-group:flow-logs"
  role_name           = "vpc-flow-logs-role"
  policy_name         = "vpc-flow-logs-policy"
  
  tags = {
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

1. Flow Logs with S3 destination and Hive partitioning:
```hcl
module "vpc_flow_logs_s3" {
  source = "path/to/modules/flow-logs"

  traffic_type         = "ALL"
  vpc_id              = "vpc-12345678"
  log_destination_type = "s3"
  log_destination     = "arn:aws:s3:::my-bucket/flow-logs/"
  
  destination_options = {
    file_format              = "parquet"
    hive_compatible_partitions = true
    per_hour_partition       = true
  }

  role_name    = "vpc-flow-logs-s3-role"
  policy_name  = "vpc-flow-logs-s3-policy"
}
```

2. Flow Logs for specific subnet with CloudWatch destination:
```hcl
module "subnet_flow_logs" {
  source = "path/to/modules/flow-logs"

  traffic_type         = "REJECT"
  subnet_id           = "subnet-12345678"
  log_destination_type = "cloud-watch-logs"
  log_destination     = "arn:aws:logs:region:account-id:log-group:subnet-flow-logs"
  
  max_aggregation_interval = 60
  
  role_name    = "subnet-flow-logs-role"
  policy_name  = "subnet-flow-logs-policy"
}
```

### Troubleshooting

Common issues and solutions:

1. **IAM Role Permission Issues**
   - Error: "User is not authorized to perform: iam:CreateRole"
   - Solution: Ensure your AWS credentials have sufficient IAM permissions
   - Required permissions: `iam:CreateRole`, `iam:PutRolePolicy`

2. **Log Destination Access**
   - Error: "Cannot create flow log. Log destination <ARN> cannot be accessed"
   - Check:
     ```bash
     aws logs describe-log-groups --log-group-name-prefix /aws/vpc/flow-logs
     ```
   - Ensure the log destination exists and is accessible

3. **Invalid Configuration**
   - Error: "InvalidParameterCombination"
   - Solution: Verify that only one of `vpc_id`, `subnet_id`, `eni_id`, or `transit_gateway_id` is specified

## Data Flow
The module manages the flow of network traffic data from AWS networking resources to your specified logging destination.

```ascii
Network Traffic --> VPC Flow Logs --> [CloudWatch Logs | S3 | Kinesis Firehose]
     |                    |                           |
     |                    |                           |
[VPC/Subnet/ENI]  [IAM Role/Policy]          [Log Destination]
```

Key component interactions:
1. Network traffic is captured based on the specified `traffic_type`
2. Flow Logs service assumes the created IAM role
3. Logs are delivered to the configured destination using the specified format
4. Destination options control how logs are organized and stored
5. IAM roles and policies manage access permissions between components