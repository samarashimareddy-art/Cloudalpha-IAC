# Cloudalpha-IAC

Infrastructure-as-Code demo for the AI DevOps Platform: the CloudAlpha AWS Terraform modules
(originally in Bitbucket `is_corp/cloudalpha-aws-vpc`, `cloudalpha-aws-s3`, `cloudalpha-aws-ec2`)
deployed with **plain Terraform** (no Terragrunt) through a GitHub Actions pipeline.

## Layout

| Path | What |
|---|---|
| `modules/vpc` | CloudAlpha VPC module (VPC, subnets, IGW, route tables, ...) |
| `modules/s3` | CloudAlpha S3 module (bucket, policies, encryption, ...) |
| `modules/ec2` | CloudAlpha EC2 module (instance, EBS, ...) |
| `infra/` | Root configuration for the `dev` demo environment - calls the three modules |
| `app/` | Sample Node.js API (built, tested and scanned by the pipeline) |

## What `infra/` creates (us-east-1)

| Resource | Name |
|---|---|
| VPC `10.50.0.0/16` + 1 public subnet + internet gateway + route table | `cloudalpha-demo-dev-vpc` |
| Security group (no inbound, outbound only) | `cloudalpha-demo-dev-ec2-sg` |
| S3 bucket (versioned, encrypted, public access blocked, HTTPS only) | `cloudalpha-demo-dev-739572512568` |
| EC2 `t3.micro`, Amazon Linux 2023, IMDSv2, encrypted gp3, no public IP | `cloudalpha-demo-dev-app` |

No NAT gateway and no flow logs, to keep the demo cheap (the EC2 instance is the main cost, ~$8/month).
Tear down with `terraform destroy` when the demo is finished.

## State

Remote state in S3 bucket `cloudalpha-demo-tfstate-739572512568` (created once by hand), key
`cloudalpha-iac/dev/terraform.tfstate`, with S3-native locking (`use_lockfile`, Terraform >= 1.10).

## AWS access

Pipelines authenticate with GitHub OIDC (no access keys), role
`arn:aws:iam::739572512568:role/github-actions-cloudalpha-iac`, trusted only for this repository's
`main` branch (and the `production` environment). Its permissions are limited to `cloudalpha-demo-*`
resources in `us-east-1`.

## Run locally

```bash
cd infra
terraform init
terraform plan
```
