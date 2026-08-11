output "vpc_id" {
  description = "ID of the personal AIPost VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs."
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs."
  value       = module.networking.private_db_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway used by the personal EC2 environment."
  value       = module.networking.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = module.networking.public_route_table_id
}

output "private_app_route_table_ids" {
  description = "IDs of private application route tables."
  value       = module.networking.private_app_route_table_ids
}

output "private_db_route_table_id" {
  description = "ID of the private database route table."
  value       = module.networking.private_db_route_table_id
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways created for the personal EC2 environment."
  value       = module.networking.nat_gateway_ids
}

output "nat_public_ips" {
  description = "Public IP addresses used by the NAT Gateways."
  value       = module.networking.nat_public_ips
}

output "nat_mode" {
  description = "NAT topology selected for the personal EC2 environment."
  value       = module.networking.nat_mode
}

output "alb_security_group_id" {
  description = "Security group ID assigned to the Application Load Balancer."
  value       = module.security.alb_security_group_id
}

output "backend_security_group_id" {
  description = "Security group ID assigned to backend workloads."
  value       = module.security.backend_security_group_id
}

output "rds_security_group_id" {
  description = "Security group ID assigned to PostgreSQL."
  value       = module.security.rds_security_group_id
}

output "frontend_bucket_name" {
  description = "Name of the private Vue frontend bucket."
  value       = module.s3_frontend.bucket_id
}

output "frontend_bucket_arn" {
  description = "ARN of the private Vue frontend bucket."
  value       = module.s3_frontend.bucket_arn
}

output "media_bucket_name" {
  description = "Name of the private AIPost media bucket."
  value       = module.s3_media.bucket_id
}

output "media_bucket_arn" {
  description = "ARN of the private AIPost media bucket."
  value       = module.s3_media.bucket_arn
}

output "s3_gateway_endpoint_id" {
  description = "ID of the S3 Gateway VPC Endpoint."
  value       = module.s3_vpc_endpoint.endpoint_id
}
output "rds_endpoint" {
  description = "PostgreSQL RDS endpoint address."
  value       = module.rds_postgresql.db_address
}

output "rds_port" {
  description = "PostgreSQL listener port."
  value       = module.rds_postgresql.db_port
}

output "rds_subnet_group_name" {
  description = "RDS database subnet group."
  value       = module.rds_postgresql.db_subnet_group_name
}

output "database_url_parameter_name" {
  description = "Parameter Store path containing DATABASE_URL."
  value       = module.ssm_parameters.database_url_parameter_name
}

output "encryption_key_parameter_name" {
  description = "Parameter Store path containing ENCRYPTION_KEY."
  value       = module.ssm_parameters.encryption_key_parameter_name
}

output "backend_instance_profile_name" {
  description = "Instance profile assigned later to backend EC2 instances."
  value       = module.ec2_iam.instance_profile_name
}

output "backend_role_arn" {
  description = "IAM role ARN used by backend EC2 instances."
  value       = module.ec2_iam.role_arn
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "backend_target_group_arn" {
  value = module.alb.target_group_arn
}

output "backend_asg_name" {
  value = module.ec2_asg.autoscaling_group_name
}

output "frontend_certificate_arn" {
  value = module.dns_acm.frontend_certificate_arn
}

output "api_certificate_arn" {
  value = module.dns_acm.api_certificate_arn
}

output "frontend_domain_name" {
  value = module.dns_acm.frontend_domain_name
}

output "api_domain_name" {
  value = module.dns_acm.api_domain_name
}