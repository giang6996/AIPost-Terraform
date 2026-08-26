data "aws_ssm_parameter" "vpc_id" {
  name = "${local.environment_prefix}/network/VPC_ID"
}

data "aws_ssm_parameter" "jenkins_subnet_id" {
  name = "${local.environment_prefix}/network/JENKINS_SUBNET_ID"
}

data "aws_ssm_parameter" "database_port" {
  name = "${local.environment_prefix}/network/DATABASE_PORT"
}

data "aws_ssm_parameter" "rds_security_group_id" {
  name = "${local.environment_prefix}/network/RDS_SECURITY_GROUP_ID"
}

data "aws_ssm_parameter" "ecr_repository_arn" {
  name = "${local.infrastructure_prefix}/ECR_REPOSITORY_ARN"
}

data "aws_ssm_parameter" "frontend_bucket_arn" {
  name = "${local.infrastructure_prefix}/FRONTEND_BUCKET_ARN"
}

data "aws_ssm_parameter" "database_url_parameter_arn" {
  name = "${local.infrastructure_prefix}/DATABASE_URL_PARAMETER_ARN"
}

data "aws_ssm_parameter" "backend_asg_arn" {
  count = var.target_environment == "ec2" ? 1 : 0

  name = "${local.infrastructure_prefix}/BACKEND_ASG_ARN"
}

data "aws_ssm_parameter" "backend_image_tag_parameter_arn" {
  count = var.target_environment == "ec2" ? 1 : 0

  name = "${local.infrastructure_prefix}/BACKEND_IMAGE_TAG_PARAMETER_ARN"
}

data "aws_ssm_parameter" "eks_cluster_arn" {
  count = var.target_environment == "eks" ? 1 : 0

  name = "${local.infrastructure_prefix}/EKS_CLUSTER_ARN"
}

data "aws_ssm_parameter" "eks_cluster_name" {
  count = var.target_environment == "eks" ? 1 : 0

  name = "${local.infrastructure_prefix}/EKS_CLUSTER_NAME"
}

data "aws_ssm_parameter" "eks_cluster_sg_id" {
  count = var.target_environment == "eks" ? 1 : 0

  name = "${local.infrastructure_prefix}/EKS_CLUSTER_SG_ID"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "jenkins_iam" {
  source = "../../modules/jenkins-iam"

  name_prefix = local.name_prefix

  ecr_repository_arn = data.aws_ssm_parameter.ecr_repository_arn.value

  frontend_bucket_arn = data.aws_ssm_parameter.frontend_bucket_arn.value

  database_url_parameter_arn = data.aws_ssm_parameter.database_url_parameter_arn.value

  backend_asg_arn = (
    var.target_environment == "ec2"
    ? data.aws_ssm_parameter.backend_asg_arn[0].value
    : null
  )

  initial_backend_image_tag_parameter_arn = (
    var.target_environment == "ec2"
    ? data.aws_ssm_parameter.backend_image_tag_parameter_arn[0].value
    : null
  )

  eks_cluster_arn = (
    var.target_environment == "eks"
    ? data.aws_ssm_parameter.eks_cluster_arn[0].value
    : null
  )

  netlify_site_id_parameter_arn = (
    var.enable_netlify
    ? aws_ssm_parameter.netlify_site_id[0].arn
    : null
  )

  netlify_auth_token_parameter_arn = (
    var.enable_netlify
    ? aws_ssm_parameter.netlify_auth_token[0].arn
    : null
  )

  common_tags = local.common_tags
}

module "jenkins_ec2" {
  source = "../../modules/jenkins-ec2"

  name_prefix = local.name_prefix

  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = var.jenkins_instance_type

  subnet_id = data.aws_ssm_parameter.jenkins_subnet_id.value

  security_group_ids = [
    aws_security_group.jenkins.id
  ]

  instance_profile_name = module.jenkins_iam.instance_profile_name

  common_tags = local.common_tags
}

resource "aws_security_group" "jenkins" {
  name        = "${local.name_prefix}-jenkins-sg"
  description = "Security group for Jenkins CI/CD controller"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-jenkins-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_jenkins" {
  security_group_id = data.aws_ssm_parameter.rds_security_group_id.value

  description                  = "Allow Jenkins CI/CD migration runner to access PostgreSQL"
  ip_protocol                  = "tcp"
  from_port                    = data.aws_ssm_parameter.database_port.value
  to_port                      = data.aws_ssm_parameter.database_port.value
  referenced_security_group_id = aws_security_group.jenkins.id
}

resource "aws_vpc_security_group_egress_rule" "jenkins_https" {
  security_group_id = aws_security_group.jenkins.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_http" {
  security_group_id = aws_security_group.jenkins.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_postgres" {
  security_group_id = aws_security_group.jenkins.id

  referenced_security_group_id = data.aws_ssm_parameter.rds_security_group_id.value

  ip_protocol = "tcp"
  from_port   = data.aws_ssm_parameter.database_port.value
  to_port     = data.aws_ssm_parameter.database_port.value
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_eks_api" {
  count = var.target_environment == "eks" ? 1 : 0

  security_group_id            = data.aws_ssm_parameter.eks_cluster_sg_id[0].value
  referenced_security_group_id = aws_security_group.jenkins.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_ssm_parameter" "netlify_auth_token" {
  count = var.enable_netlify ? 1 : 0

  name        = "${local.jenkin_prefix}/NETLIFY_AUTH_TOKEN"
  description = "AIPost Netlify auth token"
  type        = "SecureString"
  value       = var.netlify_auth_token
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "netlify_auth_token"
    }
  )
}

resource "aws_ssm_parameter" "netlify_site_id" {
  count = var.enable_netlify ? 1 : 0

  name        = "${local.jenkin_prefix}/NETLIFY_SITE_ID"
  description = "AIPost Netlify site id"
  type        = "SecureString"
  value       = var.netlify_site_id
  key_id      = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Purpose = "netlify_site_id"
    }
  )
}


resource "aws_ssm_parameter" "jenkins_role_arn" {
  name = "${local.jenkin_prefix}/ROLE_ARN"

  type  = "String"
  value = module.jenkins_iam.role_arn

  tags = merge(
    local.common_tags,
    {
      Purpose = "jenkins_role_arn"
    }
  )
}