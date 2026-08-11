resource "aws_ssm_parameter" "database_url" {
  name        = "${var.parameter_prefix}/DATABASE_URL"
  description = "AIPost PostgreSQL connection string"
  type        = "SecureString"
  value       = var.database_url
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "database-connection"
    }
  )
}

resource "aws_ssm_parameter" "encryption_key" {
  name        = "${var.parameter_prefix}/ENCRYPTION_KEY"
  description = "AIPost application encryption key"
  type        = "SecureString"
  value       = var.encryption_key
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "application-encryption"
    }
  )
}

resource "aws_ssm_parameter" "backend_image_tag" {
  name        = "/aipost/${var.environment}/backend/IMAGE_TAG"
  description = "Currently deployed AIPost backend image tag."
  type        = "String"

  value = var.initial_backend_image_tag

  tags = merge(
    var.common_tags,
    {
      Purpose = "backend-release-version"
    }
  )

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}