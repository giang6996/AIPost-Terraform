resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name_prefix}-observability"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x    = 0
        y    = 0
        width  = 12
        height = 6

        properties = {
            title  = "ALB Request Count"
            region = var.aws_region
            view   = "timeSeries"
            stat   = "Sum"
            period = 300

            metrics = [
            [
                "AWS/ApplicationELB",
                "RequestCount",
                "LoadBalancer",
                var.alb_arn_suffix
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 12
        y    = 0
        width  = 12
        height = 6

        properties = {
            title  = "ALB Target Response Time"
            region = var.aws_region
            view   = "timeSeries"
            stat   = "Average"
            period = 300

            metrics = [
            [
                "AWS/ApplicationELB",
                "TargetResponseTime",
                "LoadBalancer",
                var.alb_arn_suffix,
                "TargetGroup",
                var.target_group_arn_suffix
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 0
        y    = 6
        width  = 12
        height = 6

        properties = {
            title  = "Backend 4xx"
            region = var.aws_region
            stat   = "Sum"
            period = 300

            metrics = [
            [
                "AWS/ApplicationELB",
                "HTTPCode_Target_4XX_Count",
                "LoadBalancer",
                var.alb_arn_suffix,
                "TargetGroup",
                var.target_group_arn_suffix
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 12
        y    = 6
        width  = 12
        height = 6

        properties = {
            title  = "Unhealthy Backend Targets"
            region = var.aws_region
            stat   = "Maximum"
            period = 60

            metrics = [
            [
                "AWS/ApplicationELB",
                "UnHealthyHostCount",
                "LoadBalancer",
                var.alb_arn_suffix,
                "TargetGroup",
                var.target_group_arn_suffix
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 0
        y    = 12
        width  = 12
        height = 6

        properties = {
            title  = "Backend ASG CPU"
            region = var.aws_region
            stat   = "Average"
            period = 300

            metrics = [
            [
                "AWS/EC2",
                "CPUUtilization",
                "AutoScalingGroupName",
                var.backend_asg_name
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 12
        y    = 12
        width  = 12
        height = 6

        properties = {
            title  = "Backend ASG Memory"
            region = var.aws_region
            stat   = "Average"
            period = 300

            metrics = [
            [
                "AIPost/EC2",
                "mem_used_percent",
                "AutoScalingGroupName",
                var.backend_asg_name
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 0
        y    = 18
        width  = 12
        height = 6

        properties = {
            title  = "RDS CPU"
            region = var.aws_region
            stat   = "Average"
            period = 300

            metrics = [
            [
                "AWS/RDS",
                "CPUUtilization",
                "DBInstanceIdentifier",
                var.rds_instance_identifier
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 12
        y    = 18
        width  = 12
        height = 6

        properties = {
            title  = "RDS Connections"
            region = var.aws_region
            stat   = "Average"
            period = 300

            metrics = [
            [
                "AWS/RDS",
                "DatabaseConnections",
                "DBInstanceIdentifier",
                var.rds_instance_identifier
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 18
        y    = 12
        width  = 12
        height = 6

        properties = {
            title  = "RDS FreeStorageSpace"
            region = var.aws_region
            stat   = "Average"
            period = 300

            metrics = [
            [
                "AWS/RDS",
                "FreeStorageSpace",
                "DBInstanceIdentifier",
                var.rds_instance_identifier
            ]
            ]
        }
      },

      {
        type = "metric"
        x    = 18
        y    = 18
        width  = 12
        height = 6

        properties = {
            title  = "Backend ASG disk used"
            region = var.aws_region
            stat   = "Average"
            period = 300

            metrics = [
            [
                "AIPost/EC2",
                "disk_used_percent",
                "AutoScalingGroupName",
                var.backend_asg_name
            ]
            ]
        }
      }
    ]
  })
}