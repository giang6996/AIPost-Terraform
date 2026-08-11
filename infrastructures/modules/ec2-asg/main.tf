resource "aws_launch_template" "backend" {
  name_prefix   = "${var.name_prefix}-backend-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.backend_security_group_id
  ]

  user_data = base64encode(
    templatefile(
      "${path.module}/user-data.sh.tftpl",
      {
        aws_region          = var.aws_region
        ecr_repository_url  = var.ecr_repository_url
        container_image_tag = var.container_image_tag
        backend_port        = var.backend_port

        # Additional env variable for user data
        cors_origins           = var.cors_origins
        media_storage_provider = var.media_storage_provider
        media_public_base_url  = var.media_public_base_url
        s3_bucket_name         = var.s3_bucket_name
        ssm_parameter_prefix   = var.ssm_parameter_prefix
      }
    )
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.name_prefix}-backend"
        Tier = "application"
      }
    )
  }
}

resource "aws_autoscaling_group" "backend" {
  name = "${var.name_prefix}-backend-asg"

  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-backend"
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}



