output "role_name" {
  value = aws_iam_role.jenkins.name
}

output "role_arn" {
  value = aws_iam_role.jenkins.arn
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.jenkins.name
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.jenkins.arn
}

output "deploy_policy_arn" {
  value = aws_iam_policy.jenkins_deploy.arn
}