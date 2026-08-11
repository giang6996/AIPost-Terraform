resource "aws_cloudwatch_log_group" "backend" {
  name              = "/aipost/${var.environment}/backend"
  retention_in_days = var.retention_days

  tags = var.common_tags
}