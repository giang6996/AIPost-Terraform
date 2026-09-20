# Repository Guidelines

## Project Structure & Module Organization

- `infrastructures/environments/*/`: runnable Terraform root modules (currently `ec2`, `eks`, `jenkins`). Run `terraform` commands from one of these folders.
- `infrastructures/modules/`: reusable Terraform modules (e.g., `networking`, `security`, `alb`, `rds-postgresql`, `eks`).
- `infrastructures/bootstrap/terraform-state/`: creates remote state prerequisites (typically an S3 bucket; optionally add DynamoDB locking if your workflow requires it).

## Build, Test, and Development Commands

Run from an environment directory, for example `infrastructures/environments/ec2`:

- `terraform init`: installs providers/modules and configures the backend.
- `terraform fmt -recursive`: formats all `.tf` files (run before committing).
- `terraform validate`: static validation of configuration.
- `terraform plan -out=tfplan`: produces an execution plan artifact for review.
- `terraform apply tfplan`: applies the reviewed plan (preferred over applying directly).
- `terraform destroy`: destructive; use only with explicit intent and correct AWS account/profile.

## Coding Style & Naming Conventions

- Formatting: rely on `terraform fmt` (do not hand-align whitespace).
- Indentation: Terraform default (2 spaces) and one attribute per line where practical.
- Naming: variables/outputs use `snake_case`; keep module inputs consistent across environments.

## Testing Guidelines

This repo primarily uses Terraform’s built-in checks:

- Minimum bar for changes: `terraform fmt -recursive` and `terraform validate`.
- Prefer reviewing a saved plan (`tfplan`) before applying.

## Commit & Pull Request Guidelines

- Commits generally follow Conventional Commits (seen in history): `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`, optionally `feat(jenkins): ...`. Prefer lowercase type + short imperative summary.
- PRs: include a brief description, the target environment(s) (`ec2`/`eks`/`jenkins`), and the output of `terraform plan` (sanitized). Link related issues/tickets when applicable.

## Security & Configuration Tips

- Never commit secrets or local artifacts: `terraform.tfvars`, `.terraform/`, `terraform.tfstate*`, `tfplan`.
- Use `infrastructures/environments/*/terraform.tfvars.example` as the starting point for local config.
- Double-check `aws_profile`/credentials and region before `apply` to avoid modifying the wrong AWS account.
