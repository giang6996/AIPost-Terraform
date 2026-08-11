output "frontend_certificate_arn" {
  description = "Validated ACM certificate ARN for CloudFront."
  value       = aws_acm_certificate_validation.frontend.certificate_arn
}

output "api_certificate_arn" {
  description = "Validated ACM certificate ARN for the API ALB."
  value       = aws_acm_certificate_validation.api.certificate_arn
}

output "frontend_domain_name" {
  value = var.frontend_domain_name
}

output "api_domain_name" {
  value = var.api_domain_name
}