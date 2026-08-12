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

resource "aws_ssm_parameter" "s3_frontend_bucket" {
  name        = "${var.parameter_frontend_prefix}/S3_FRONTEND_BUCKET"
  description = "AIPost S3 Frontend Bucket"
  type        = "String"
  value       = var.s3_frontend_bucket

  tags = merge(
    var.common_tags,
    {
      Purpose = "s3-frontend-bucket"
    }
  )
}

resource "aws_ssm_parameter" "frontend_tinymce_api_key" {
  name        = "${var.parameter_frontend_prefix}/TINYMCE_API_KEY"
  description = "Tinymce text editor API key for AIPost frontend application"
  type        = "SecureString"
  value       = var.frontend_tinymce_api_key
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "frontend_tinymce_api_key"
    }
  )
}

resource "aws_ssm_parameter" "backend_image_tag" {
  name        = "${var.parameter_prefix}/IMAGE_TAG"
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