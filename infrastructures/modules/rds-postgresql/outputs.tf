output "db_instance_id" {
  description = "RDS PostgreSQL instance identifier."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the RDS PostgreSQL instance."
  value       = aws_db_instance.this.arn
}

output "db_address" {
  description = "DNS address of the PostgreSQL endpoint."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "PostgreSQL listener port."
  value       = aws_db_instance.this.port
}

output "database_name" {
  description = "Initial PostgreSQL database name."
  value       = var.database_name
}

output "master_username" {
  description = "PostgreSQL administrative username."
  value       = var.master_username
  sensitive   = true
}

output "db_subnet_group_name" {
  description = "Name of the database subnet group."
  value       = aws_db_subnet_group.this.name
}