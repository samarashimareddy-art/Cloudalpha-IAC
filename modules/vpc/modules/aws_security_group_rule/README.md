# AWS Security Group Rule Terraform Module

## Description
This Terraform module creates AWS Security Group Rules using a map of rules. It provides a flexible way to manage multiple security group rules through a single module.

## Features
- Supports both ingress and egress rules
- Handles IPv4 and IPv6 CIDR blocks
- Supports prefix lists
- Allows security group references
- Configurable port ranges and protocols

## Requirements
- Terraform >= 0.12
- AWS Provider

## Usage
```hcl
module "security_group_rules" {
  source = "./modules/aws_security_group_rule"

  rules = {
    rule1 = {
      type              = "ingress"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      security_group_id = "sg-xxxxx"
      cidr_blocks       = ["10.0.0.0/16"]
      description       = "HTTPS access"
    },
    rule2 = {
      type              = "egress"
      from_port         = -1
      to_port           = -1
      protocol          = "-1"
      security_group_id = "sg-xxxxx"
      cidr_blocks       = ["0.0.0.0/0"]
      description       = "Allow all outbound traffic"
    }
  }
}


Copy

Insert at cursor
markdown
Input Variables
Required Variables
rules - (Required) Map of security group rules. Each rule should contain:

type - (Required) Type of rule (ingress or egress)

from_port - (Required) Start port

to_port - (Required) End port

protocol - (Required) Protocol (-1 means all)

security_group_id - (Required) ID of the security group

Optional Variables in Rules
cidr_blocks - (Optional) List of IPv4 CIDR blocks

ipv6_cidr_blocks - (Optional) List of IPv6 CIDR blocks

prefix_list_ids - (Optional) List of prefix list IDs

self - (Optional) Whether to allow self-referencing

source_security_group_id - (Optional) Security group to allow access from

description - (Optional) Description of the rule

Notes
Only one of cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, self, or source_security_group_id should be specified per rule

The module uses the lookup function to safely handle optional parameters

All rules must have a unique key in the rules map

Best Practices
Always provide descriptions for your security group rules

Use the principle of least privilege when defining rules

Avoid using overly permissive CIDR blocks

Document any changes to security group rules

Use meaningful names for rule keys in the map

License
Specify your license here


This README provides clear documentation