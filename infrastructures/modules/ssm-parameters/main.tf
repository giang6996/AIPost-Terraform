
resource "aws_ssm_parameter" "database_url" {
  name        = "${var.parameter_api_prefix}/DATABASE_URL"
  description = "AIPost PostgreSQL connection string"
  type        = "SecureString"
  value       = var.database_url
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "database-connection"
    }
  )
}

resource "aws_ssm_parameter" "encryption_key" {
  name        = "${var.parameter_api_prefix}/ENCRYPTION_KEY"
  description = "AIPost application encryption key"
  type        = "SecureString"
  value       = var.encryption_key
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "application-encryption"
    }
  )
}

resource "aws_ssm_parameter" "backend_asg_name" {

  // Optional for EKS
  count = var.backend_asg_name != null ? 1 : 0

  name        = "${var.parameter_api_prefix}/BACKEND_ASG_NAME"
  description = "AIPost backend auto scaling group"
  type        = "String"
  value       = var.backend_asg_name

  tags = merge(
    var.common_tags,
    {
      Purpose = "backend_asg_name"
    }
  )
}

resource "aws_ssm_parameter" "ecr_repository_url" {
  name        = "${var.parameter_api_prefix}/ECR_REPOSITORY_URL"
  description = "AIPost ECR Repository URL"
  type        = "String"
  value       = var.ecr_repository_url

  tags = merge(
    var.common_tags,
    {
      Purpose = "ecr_repository_url"
    }
  )
}

resource "aws_ssm_parameter" "api_url" {
  name        = "${var.parameter_api_prefix}/API_URL"
  description = "AIPost Backend API url"
  type        = "String"
  value       = var.api_url

  tags = merge(
    var.common_tags,
    {
      Purpose = "api_url"
    }
  )
}

resource "aws_ssm_parameter" "backend_image_tag" {

  // Optional for EKS
  count = var.initial_backend_image_tag != null ? 1 : 0

  name        = "${var.parameter_api_prefix}/IMAGE_TAG"
  description = "Currently deployed AIPost backend image tag."
  type        = "String"

  value = var.initial_backend_image_tag

  tags = merge(
    var.common_tags,
    {
      Purpose = "backend-release-version"
    }
  )

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "s3_frontend_bucket" {
  name        = "${var.parameter_frontend_prefix}/S3_FRONTEND_BUCKET"
  description = "AIPost S3 Frontend Bucket"
  type        = "String"
  value       = var.s3_frontend_bucket

  tags = merge(
    var.common_tags,
    {
      Purpose = "s3-frontend-bucket"
    }
  )
}

resource "aws_ssm_parameter" "app_url" {
  name        = "${var.parameter_frontend_prefix}/APP_URL"
  description = "AIPost Frontend URL"
  type        = "String"
  value       = var.app_url

  tags = merge(
    var.common_tags,
    {
      Purpose = "app_url"
    }
  )
}

resource "aws_ssm_parameter" "frontend_tinymce_api_key" {
  name        = "${var.parameter_frontend_prefix}/TINYMCE_API_KEY"
  description = "Tinymce text editor API key for AIPost frontend application"
  type        = "SecureString"
  value       = var.frontend_tinymce_api_key
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "frontend_tinymce_api_key"
    }
  )
}

resource "aws_ssm_parameter" "database_port" {
  name        = "${var.parameter_network_prefix}/DATABASE_PORT"
  description = "AIPost PostgreSQL connection port"
  type        = "String"
  value       = tostring(var.database_port)

  tags = merge(
    var.common_tags,
    {
      Purpose = "database_port"
    }
  )
}


resource "aws_ssm_parameter" "vpc_id" {
  name  = "${var.parameter_network_prefix}/VPC_ID"
  type  = "String"
  value = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "vpc_id"
    }
  )
}

resource "aws_ssm_parameter" "jenkins_subnet_id" {
  name  = "${var.parameter_network_prefix}/JENKINS_SUBNET_ID"
  type  = "String"
  value = var.jenkins_subnet_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "jenkins_subnet_id"
    }
  )
}

resource "aws_ssm_parameter" "rds_security_group_id" {
  name  = "${var.parameter_network_prefix}/RDS_SECURITY_GROUP_ID"
  type  = "String"
  value = var.rds_security_group_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "rds_security_group_id"
    }
  )
}

resource "aws_ssm_parameter" "ecr_repository_arn" {
  name  = "${var.parameter_infrastructure_prefix}/ECR_REPOSITORY_ARN"
  type  = "String"
  value = var.ecr_repository_arn

  tags = merge(
    var.common_tags,
    {
      Purpose = "ecr_repository_arn"
    }
  )
}

resource "aws_ssm_parameter" "frontend_bucket_arn" {
  name  = "${var.parameter_infrastructure_prefix}/FRONTEND_BUCKET_ARN"
  type  = "String"
  value = var.frontend_bucket_arn

  tags = merge(
    var.common_tags,
    {
      Purpose = "frontend_bucket_arn"
    }
  )
}

resource "aws_ssm_parameter" "database_url_parameter_arn" {
  name  = "${var.parameter_infrastructure_prefix}/DATABASE_URL_PARAMETER_ARN"
  type  = "String"
  value = aws_ssm_parameter.database_url.arn

  tags = merge(
    var.common_tags,
    {
      Purpose = "database_url_parameter_arn"
    }
  )
}

resource "aws_ssm_parameter" "backend_asg_arn" {
  count = var.enable_ec2_metadata ? 1 : 0
  
  name  = "${var.parameter_infrastructure_prefix}/BACKEND_ASG_ARN"
  type  = "String"
  value = var.backend_asg_arn

  tags = merge(
    var.common_tags,
    {
      Purpose = "backend_asg_arn"
    }
  )
}

resource "aws_ssm_parameter" "backend_image_tag_parameter_arn" {
  count = var.initial_backend_image_tag != null ? 1 : 0
  
  name  = "${var.parameter_infrastructure_prefix}/BACKEND_IMAGE_TAG_PARAMETER_ARN"
  type  = "String"
  value = aws_ssm_parameter.backend_image_tag[0].arn

  tags = merge(
    var.common_tags,
    {
      Purpose = "backend_image_tag_parameter_arn"
    }
  )
}

resource "aws_ssm_parameter" "eks_cluster_arn" {
  count = var.enable_eks_metadata ? 1 : 0

  name  = "${var.parameter_infrastructure_prefix}/EKS_CLUSTER_ARN"
  type  = "String"
  value = var.eks_cluster_arn

  tags = merge(
    var.common_tags,
    {
      Purpose = "eks_cluster_arn"
    }
  )
}

resource "aws_ssm_parameter" "eks_cluster_name" {
  count = var.enable_eks_metadata ? 1 : 0

  name  = "${var.parameter_infrastructure_prefix}/EKS_CLUSTER_NAME"
  type  = "String"
  value = var.eks_cluster_name

  tags = merge(
    var.common_tags,
    {
      Purpose = "eks_cluster_name"
    }
  )
}

resource "aws_ssm_parameter" "eks_cluster_sg_id" {
  count = var.enable_eks_metadata ? 1 : 0

  name  = "${var.parameter_infrastructure_prefix}/EKS_CLUSTER_SG_ID"
  type  = "String"
  value = var.eks_cluster_sg_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "eks_cluster_sg_id"
    }
  )
}
