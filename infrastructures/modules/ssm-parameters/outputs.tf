output "database_url_parameter_name" {
  description = "Name of the DATABASE_URL parameter."
  value       = aws_ssm_parameter.database_url.name
}

output "database_url_parameter_arn" {
  description = "ARN of the DATABASE_URL parameter."
  value       = aws_ssm_parameter.database_url.arn
}

output "encryption_key_parameter_name" {
  description = "Name of the ENCRYPTION_KEY parameter."
  value       = aws_ssm_parameter.encryption_key.name
}

output "encryption_key_parameter_arn" {
  description = "ARN of the ENCRYPTION_KEY parameter."
  value       = aws_ssm_parameter.encryption_key.arn
}

output "s3_frontend_bucket_parameter_name" {
  description = "Name of the S3_FRONTEND_BUCKET parameter."
  value       = aws_ssm_parameter.s3_frontend_bucket.name
}

output "s3_frontend_bucket_parameter_arn" {
  description = "ARN of the S3_FRONTEND_BUCKET parameter."
  value       = aws_ssm_parameter.s3_frontend_bucket.arn
}

output "frontend_tinymce_api_key_parameter_name" {
  description = "Name of the frontend TinyMCE API key SSM parameter."
  value       = aws_ssm_parameter.frontend_tinymce_api_key.name
}

output "frontend_tinymce_api_key_parameter_arn" {
  description = "ARN of the frontend TinyMCE API key SSM parameter."
  value       = aws_ssm_parameter.frontend_tinymce_api_key.arn
}

output "backend_image_tag_parameter_arn" {
  description = "ARN of the IMAGE_TAG parameter."
  value       = aws_ssm_parameter.backend_image_tag.arn
}

