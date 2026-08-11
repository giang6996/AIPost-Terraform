locals {
  project     = "aipost"
  environment = "ec2"
  name_prefix = "${local.project}-${local.environment}"

  # Bucket name using current account ID to ensure globalally uniqueness
  frontend_bucket_name = "${local.name_prefix}-frontend-${data.aws_caller_identity.current.account_id}"
  media_bucket_name    = "${local.name_prefix}-media-${data.aws_caller_identity.current.account_id}"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
    Owner       = "giangnc"
  }

  database_url = format(
    "postgresql://%s:%s@%s:%s/%s",
    urlencode(var.database_username),
    urlencode(var.database_password),
    module.rds_postgresql.db_address,
    module.rds_postgresql.db_port,
    var.database_name
  )
}