# AIPost Infrastructure (Terraform)

Terraform codebase for provisioning AWS infrastructure used by the **AIPost** project.

## Repo function

Currently, the `ec2` environment provisions a seperated AWS stack for running AIPost:

- VPC networking (public + private subnets, NAT)
- Security groups for ALB / backend / RDS / Jenkins
- S3 buckets (frontend + media) and an S3 Gateway VPC Endpoint
- RDS PostgreSQL
- SSM Parameter Store entries for backend secrets/config (e.g. `DATABASE_URL`, encryption key)
- CloudWatch Logs group(s)
- ECR repository for backend images
- Application Load Balancer + Route 53 records
- Optional CloudFront + ACM for the frontend domain (toggle via `enable_cloudfront`)
- Jenkins (EC2 + IAM) for CI/CD

## Repo layout

- `infrastructures/environments/ec2/`: runnable Terraform root module (EC2-based deployment)
- `infrastructures/environments/eks/`: placeholder (files exist but are empty)
- `infrastructures/modules/`: reusable Terraform modules

### Modules

Modules under `infrastructures/modules/` include:

- `networking`: VPC, subnets, route tables, NAT
- `security`: security groups (ALB, backend, RDS, Jenkins)
- `alb`: ALB + target group
- `ec2-asg`: backend Auto Scaling Group (pulls container image from ECR)
- `ec2-iam`: backend instance role/profile (SSM, S3, ECR, CloudWatch)
- `ecr`: ECR repository for backend images
- `rds-postgresql`: PostgreSQL RDS instance + subnet group
- `ssm-parameters`: SSM Parameter Store entries consumed by the backend
- `cloudwatch-logs`: log groups + retention
- `s3-fe`: S3 bucket for frontend assets
- `s3-media`: S3 bucket for uploaded media
- `s3-vpc-endpoint`: S3 Gateway Endpoint for private subnets
- `dns-acm`: Route 53 records + ACM certs (includes `us-east-1` cert for CloudFront)
- `cloudfront`: (optional) CloudFront distribution for the frontend
- `jenkins-iam`, `jenkins-ec2`: Jenkins IAM + EC2 instance

## Prerequisites

- Terraform `>= 1.8.0, < 2.0.0`
- AWS credentials available via the configured profile (see `aws_profile`)
- A public Route 53 hosted zone for `root_domain_name` (used for frontend/API records + ACM validation)

## Quick start (EC2 environment)

1) Create your tfvars file (do **not** commit secrets):

- Copy `infrastructures/environments/ec2/terraform.tfvars.example` to `infrastructures/environments/ec2/terraform.tfvars`
- Set at least:
  - `database_password` using local secret
  - `encryption_key` using local secret
  - domain variables (`root_domain_name`, `frontend_domain_name`, `api_domain_name`) if you’re not using defaults

2) Initialize and apply:

```bash
cd infrastructures/environments/ec2
terraform init
terraform plan
terraform apply
```

3) Useful outputs:

- `alb_dns_name` (ALB endpoint)
- `ecr_repository_url` (push backend images here)
- `database_url_parameter_name` and `encryption_key_parameter_name` (SSM paths for backend config)
- `frontend_domain_name` and `api_domain_name`

## Important notices

- **Do not commit** `terraform.tfvars`, any `terraform.tfstate*`, or `.terraform/`.
- The repo currently includes modules and patterns that create **billable AWS resources** (NAT Gateway, RDS, ALB, CloudFront, etc.). Review costs before applying.
- For team usage, consider configuring a **remote backend** (S3 + DynamoDB) instead of local state.
