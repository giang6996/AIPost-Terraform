locals {
  project          = "aipost"
  name_prefix      = "${local.project}-${var.target_environment}"

  environment_prefix = "/${local.project}/${var.target_environment}"

  common_tags = {
    Project     = local.project
    Environment = var.target_environment
    ManagedBy   = "Terraform"
    Owner       = "giangnc"
  }
}