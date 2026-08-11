output "repository_name" {
  description = "Name of the AIPost backend ECR repository."
  value       = aws_ecr_repository.backend.name
}

output "repository_arn" {
  description = "ARN of the backend ECR repository."
  value       = aws_ecr_repository.backend.arn
}

output "repository_url" {
  description = "Docker repository URL used when pushing and pulling backend images."
  value       = aws_ecr_repository.backend.repository_url
}

