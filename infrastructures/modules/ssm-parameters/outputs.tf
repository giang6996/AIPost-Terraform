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