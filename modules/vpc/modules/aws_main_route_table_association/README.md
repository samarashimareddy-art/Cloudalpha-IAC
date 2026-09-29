# AWS Main Route Table Association Terraform Module

## Description
This Terraform module manages the main route table association for an AWS VPC. It allows you to explicitly set the main route table for a VPC by creating an `aws_main_route_table_association` resource.

## Features
- Associates a specified route table as the main route table for a VPC
- Simple and straightforward implementation
- Helps in maintaining explicit and clear routing configurations

## Requirements
- Terraform >= 0.12
- AWS Provider

## Usage
```hcl
module "main_route_table_association" {
  source         = "./modules/aws_main_route_table_association"
  vpc_id         = "vpc-xxxxxxxx"
  route_table_id = "rtb-xxxxxxxx"
}


Copy

Insert at cursor
markdown
Input Variables
Name	Description	Type	Required
vpc_id	The ID of the VPC whose main route table should be set	string	yes
route_table_id	The ID of the route table to set as the main route table	string	yes
Notes
Only one main route table can be associated with a VPC at a time

Creating this association will remove any existing main route table association

Deleting this resource will reset the main route table to the default route table

Best Practices
Always maintain proper documentation of route table associations

Use meaningful names for your route tables

Consider the impact on existing routing before changing the main route table

Implement proper testing before applying changes in production environments

Related Resources
AWS VPC

AWS Route Tables

AWS Route Table Associations


This README provides essential informatio