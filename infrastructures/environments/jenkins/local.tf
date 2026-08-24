locals {
  project     = "aipost"
  name_prefix = "${local.project}-${var.target_environment}"

  environment_prefix = "/${local.project}/${var.target_environment}"

  network_prefix        = "${local.environment_prefix}/network"
  infrastructure_prefix = "${local.environment_prefix}/infrastructure"
  jenkin_prefix = "${local.environment_prefix}/jenkins"

  common_tags = {
    Project     = local.project
    Environment = var.target_environment
    ManagedBy   = "Terraform"
    Owner       = "giangnc"
  }
}