output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer."
  value       = aws_security_group.alb.id
}

output "backend_security_group_id" {
  description = "Security group ID for EC2 or EKS backend workloads."
  value       = aws_security_group.backend.id
}

output "rds_security_group_id" {
  description = "Security group ID for PostgreSQL."
  value       = aws_security_group.rds.id
}
