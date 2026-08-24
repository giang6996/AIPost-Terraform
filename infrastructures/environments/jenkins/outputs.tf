output "target_environment" {
  value = var.target_environment
}

output "target_vpc_id" {
  value = nonsensitive(data.aws_ssm_parameter.vpc_id.value)
}

output "jenkins_security_group_id" {
  description = " Security group ID for Jenkins EC2 Instance."
  value       = aws_security_group.jenkins.id
}

output "jenkins_subnet_id" {
  value = nonsensitive(data.aws_ssm_parameter.jenkins_subnet_id.value)
}

output "jenkins_instance_id" {
  value = module.jenkins_ec2.instance_id
}

output "jenkins_role_arn" {
  value = module.jenkins_iam.role_arn
}