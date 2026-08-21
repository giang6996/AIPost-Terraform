output "target_environment" {
  value = var.target_environment
}

output "target_vpc_id" {
  value = data.aws_ssm_parameter.vpc_id.value
}

output "jenkins_subnet_id" {
  value = data.aws_ssm_parameter.jenkins_subnet_id.value
}

output "jenkins_instance_id" {
  value = module.jenkins_ec2.instance_id
}

output "jenkins_role_arn" {
  value = module.jenkins_iam.role_arn
}