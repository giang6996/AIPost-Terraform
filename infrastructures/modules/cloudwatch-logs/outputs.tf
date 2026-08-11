output "backend_log_group_name" {
  description = "Name of the CloudWatch Log Group used by the AIPost backend."
  value       = aws_cloudwatch_log_group.backend.name
}

output "backend_log_group_arn" {
  description = "ARN of the CloudWatch Log Group used by the AIPost backend."
  value       = aws_cloudwatch_log_group.backend.arn
}