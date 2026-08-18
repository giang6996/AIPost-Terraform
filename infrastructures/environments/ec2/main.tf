module "networking" {
  source = "../../modules/networking"

  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr

  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  nat_mode    = var.nat_mode
  common_tags = local.common_tags
}

module "security" {
  source = "../../modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.networking.vpc_id

  backend_port  = var.backend_port
  database_port = var.database_port

  common_tags = local.common_tags
}

module "s3_frontend" {
  source = "../../modules/s3-fe"

  bucket_name = local.frontend_bucket_name
  common_tags = local.common_tags
}

module "s3_media" {
  source = "../../modules/s3-media"

  bucket_name = local.media_bucket_name
  common_tags = local.common_tags
}

module "s3_vpc_endpoint" {
  source = "../../modules/s3-vpc-endpoint"

  name_prefix = local.name_prefix
  aws_region  = var.aws_region
  vpc_id      = module.networking.vpc_id

  route_table_ids = module.networking.private_app_route_table_ids

  common_tags = local.common_tags
}

module "rds_postgresql" {
  source = "../../modules/rds-postgresql"

  name_prefix = local.name_prefix

  db_subnet_ids         = module.networking.private_db_subnet_ids
  rds_security_group_id = module.security.rds_security_group_id

  database_name   = var.database_name
  master_username = var.database_username
  master_password = var.database_password

  engine_version = var.database_engine_version
  instance_class = var.database_instance_class

  multi_az = var.database_multi_az

  allocated_storage     = 20
  max_allocated_storage = 50

  backup_retention_days = 7
  deletion_protection   = false
  skip_final_snapshot   = true
  apply_immediately     = true

  common_tags = local.common_tags
}

module "ssm_parameters" {
  source = "../../modules/ssm-parameters"

  parameter_api_prefix = "${local.parameter_prefix}/backend"

  parameter_frontend_prefix = "${local.parameter_prefix}/frontend"

  database_url     = local.database_url
  encryption_key   = var.encryption_key
  backend_asg_name = module.ec2_asg.autoscaling_group_name

  ecr_repository_url = module.ecr.repository_url
  api_url            = var.api_domain_name

  app_url                  = var.frontend_domain_name
  s3_frontend_bucket       = module.s3_frontend.bucket_name
  frontend_tinymce_api_key = var.frontend_tinymce_api_key


  common_tags = local.common_tags
}

module "cloudwatch_logs" {
  source = "../../modules/cloudwatch-logs"

  environment    = local.environment
  retention_days = var.retention_days
  common_tags    = local.common_tags
}

module "ec2_iam" {
  source = "../../modules/ec2-iam"

  name_prefix = local.name_prefix

  media_bucket_arn = module.s3_media.bucket_arn

  parameter_arns = [
    module.ssm_parameters.database_url_parameter_arn,
    module.ssm_parameters.encryption_key_parameter_arn
  ]

  ecr_repository_arn = module.ecr.repository_arn

  cloudwatch_log_group_arn = module.cloudwatch_logs.backend_log_group_arn

  common_tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix = local.name_prefix

  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  certificate_arn       = module.dns_acm.api_certificate_arn

  backend_port      = var.backend_port
  health_check_path = "/health"

  common_tags = local.common_tags
}

module "ec2_asg" {
  source = "../../modules/ec2-asg"

  name_prefix = local.name_prefix

  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = var.backend_instance_type

  private_subnet_ids        = module.networking.private_app_subnet_ids
  backend_security_group_id = module.security.backend_security_group_id
  instance_profile_name     = module.ec2_iam.instance_profile_name

  target_group_arn = module.alb.target_group_arn

  aws_region          = var.aws_region
  ecr_repository_url  = module.ecr.repository_url
  container_image_tag = var.backend_image_tag

  backend_port = var.backend_port

  cors_origins           = var.cors_origins
  media_storage_provider = "s3"
  media_public_base_url  = var.media_public_base_url

  s3_bucket_name = module.s3_media.bucket_id

  ssm_parameter_prefix = var.ssm_parameter_prefix

  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_capacity
  max_size         = var.asg_max_size

  common_tags = local.common_tags
}

module "dns_acm" {
  source = "../../modules/dns-acm"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  hosted_zone_id = data.aws_route53_zone.main.zone_id

  frontend_domain_name = var.frontend_domain_name
  api_domain_name      = var.api_domain_name

  common_tags = local.common_tags
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  name_prefix = local.name_prefix

  enable_distribution = var.enable_cloudfront

  frontend_bucket_id = module.s3_frontend.bucket_id

  frontend_bucket_arn = module.s3_frontend.bucket_arn

  frontend_bucket_regional_domain_name = module.s3_frontend.regional_domain_name

  frontend_domain_name = var.frontend_domain_name

  frontend_certificate_arn = module.dns_acm.frontend_certificate_arn

  common_tags = local.common_tags
}


module "jenkins_iam" {
  source = "../../modules/jenkins-iam"

  name_prefix = local.name_prefix

  ecr_repository_arn = module.ecr.repository_arn

  backend_asg_arn = module.ec2_asg.autoscaling_arn

  frontend_bucket_arn = module.s3_frontend.bucket_arn

  database_url_parameter_arn = module.ssm_parameters.database_url_parameter_arn

  backend_image_tag_parameter_arn = module.ssm_parameters.backend_image_tag_parameter_arn

  common_tags = local.common_tags
}

module "jenkins_ec2" {
  source = "../../modules/jenkins-ec2"

  name_prefix = local.name_prefix

  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = var.jenkins_instance_type

  subnet_id = module.networking.private_app_subnet_ids[0]

  security_group_ids = [
    module.security.jenkins_security_group_id
  ]

  instance_profile_name = module.jenkins_iam.instance_profile_name

  common_tags = local.common_tags
}


# Create subdomain record at root before creating TLS
resource "aws_route53_record" "frontend" {
  # Debug
  count = var.enable_cloudfront ? 1 : 0

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.frontend_domain_name
  type    = "A"

  alias {
    name                   = module.cloudfront.distribution_domain_name
    zone_id                = module.cloudfront.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "frontend_ipv6" {
  # Debug
  count = var.enable_cloudfront ? 1 : 0

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.frontend_domain_name
  type    = "AAAA"

  alias {
    name                   = module.cloudfront.distribution_domain_name
    zone_id                = module.cloudfront.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.api_domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

// Parameter Prefix with fixed name for Jenkin
resource "aws_ssm_parameter" "environment_parameter_prefix" {
  name  = "/aipost-bootstrap/ec2"
  type  = "String"
  value = local.parameter_prefix

  description = "SSM parameter namespace used by Jenkins to discover the EC2 environment."
}

# retrieve current AWS IAM account identity
data "aws_caller_identity" "current" {}

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

data "aws_route53_zone" "main" {
  name         = var.root_domain_name
  private_zone = false
}


