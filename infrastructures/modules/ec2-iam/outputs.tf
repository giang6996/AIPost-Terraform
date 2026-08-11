output "role_name" {
  description = "Name of the IAM role used by AIPost backend EC2 instances."
  value       = aws_iam_role.backend.name
}

output "role_arn" {
  description = "ARN of the IAM role used by AIPost backend EC2 instances."
  value       = aws_iam_role.backend.arn
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile containing the backend IAM role."
  value       = aws_iam_instance_profile.backend.name
}

output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile."
  value       = aws_iam_instance_profile.backend.arn
}

output "backend_access_policy_arn" {
  description = "ARN of the custom least-privilege backend access policy."
  value       = aws_iam_policy.backend_access.arn
}