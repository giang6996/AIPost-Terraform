resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "${var.name_prefix}-alb-unhealthy-targets"
  alarm_description   = "ALB has one or more unhealthy backend targets."

  alarm_actions = [
    var.sns_topic_arn
  ]

  ok_actions = [
    var.sns_topic_arn
  ]

  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Maximum"

  period              = 60
  evaluation_periods  = 2
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "ec2_status_check" {
  alarm_name = "${var.name_prefix}-ec2-status-check"
  alarm_description = "EC2 instance is failing healthcheck over time threshold"

  alarm_actions = [
    var.sns_topic_arn
  ]

  ok_actions = [
    var.sns_topic_arn
  ]

  namespace   = "AWS/EC2"
  metric_name = "StatusCheckFailed"
  statistic   = "Maximum"

  period              = 60
  evaluation_periods  = 2
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.backend_asg_name
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name = "${var.name_prefix}-ec2-cpu-high"
  alarm_description = "EC2 CPU utilization within ASG is over 85% over 2 minutes"

  alarm_actions = [
    var.sns_topic_arn
  ]

  ok_actions = [
    var.sns_topic_arn
  ]

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  period              = 60
  evaluation_periods  = 2
  threshold           = 85
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.backend_asg_name
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "rds_free_storage_low" {
  alarm_name        = "${var.name_prefix}-rds-free-storage-low"
  alarm_description = "RDS free storage is below the configured threshold."

  alarm_actions = [
    var.sns_topic_arn
  ]

  ok_actions = [
    var.sns_topic_arn
  ]

  namespace   = "AWS/RDS"
  metric_name = "FreeStorageSpace"
  statistic   = "Average"

  period             = 300
  evaluation_periods = 2

  threshold           = 5 * 1024 * 1024 * 1024 # Byte to Gigabyte, around 5368709120 Byte
  comparison_operator = "LessThanThreshold"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  treat_missing_data = "notBreaching"
}

// Custom metric
resource "aws_cloudwatch_metric_alarm" "ec2_memory_high" {
  alarm_name = "${var.name_prefix}-ec2-memory-high"
  alarm_description = "EC2 storage is over 85% usage"

  alarm_actions = [
    var.sns_topic_arn
  ]

  ok_actions = [
    var.sns_topic_arn
  ]

  namespace   = "AIPost/EC2"
  metric_name = "mem_used_percent"
  statistic   = "Average"

  period              = 300
  evaluation_periods  = 2
  threshold           = 85
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"
}