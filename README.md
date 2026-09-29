# Cloudalpha-IAC

Sample project for the AI DevOps Platform end-to-end demo: one application and one infrastructure example.

| Folder | What | Deploys to |
|---|---|---|
| `app/` | Node.js API (`/health`, `/api/greeting`) with unit tests and a Dockerfile | AWS EC2 |
| `infra/` | Terraform that creates an S3 bucket `cloudalpha-demo-<env>-<suffix>` | AWS S3 |

The CI/CD pipeline is not written by hand: the AI DevOps Platform generates it and opens a pull request.

## AWS access

Pipelines authenticate with GitHub OIDC (no access keys), using the role
`arn:aws:iam::739572512568:role/github-actions-cloudalpha-iac`.
The role trusts only this repository's `main` branch and allows S3 (`cloudalpha-demo-*` buckets) and EC2 in `us-east-1`.

## Run locally

```bash
cd app
npm test
npm start          # http://localhost:3000/health
```

```bash
cd infra
terraform init
terraform plan
```
