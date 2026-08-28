module "networking" {
  source = "../../modules/networking"

  name_prefix = local.name_prefix

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs

  private_app_subnet_cidrs = var.private_app_subnet_cidrs

  private_db_subnet_cidrs = var.private_db_subnet_cidrs

  nat_mode = var.nat_mode

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

module "eks" {
  source = "../../modules/eks"

  name_prefix = local.name_prefix

  cluster_version = var.eks_cluster_version

  private_app_subnet_ids = module.networking.private_app_subnet_ids

  node_instance_types = var.eks_node_instance_types

  node_min_size = var.eks_node_min_size

  node_desired_size = var.eks_node_desired_size

  node_max_size = var.eks_node_max_size

  secrets_store_provider_version = var.secrets_store_provider_version

  common_tags = local.common_tags
}

module "eks-workload-iam" {
  source = "../../modules/eks-workload-iam"

  name_prefix = local.name_prefix

  cluster_name = module.eks.cluster_name

  namespace = var.namespace

  service_account = var.service_account

  media_bucket_arn = module.s3_media.bucket_arn

  parameter_arns = [
    module.ssm_parameters.database_url_parameter_arn,
    module.ssm_parameters.encryption_key_parameter_arn
  ]

  common_tags = local.common_tags

}

module "eks_lb_controller_iam" {
  source = "../../modules/eks-lb-controller-iam"

  name_prefix  = local.name_prefix
  cluster_name = module.eks.cluster_name

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
  database_port   = var.database_port

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

module "ecr" {
  source = "../../modules/ecr"

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

module "ssm_parameters" {
  source = "../../modules/ssm-parameters"

  enable_eks_metadata = true

  parameter_api_prefix = "${local.parameter_prefix}/backend"

  parameter_frontend_prefix = "${local.parameter_prefix}/frontend"


  parameter_network_prefix = "${local.parameter_prefix}/network"

  parameter_infrastructure_prefix = "${local.parameter_prefix}/infrastructure"

  database_url   = local.database_url
  encryption_key = var.encryption_key

  ecr_repository_url = module.ecr.repository_url
  api_url            = var.api_domain_name

  app_url                  = var.frontend_domain_name
  s3_frontend_bucket       = module.s3_frontend.bucket_name
  frontend_tinymce_api_key = var.frontend_tinymce_api_key

  vpc_id                = module.networking.vpc_id
  jenkins_subnet_id     = module.networking.private_app_subnet_ids[0]
  database_port         = module.rds_postgresql.db_port
  rds_security_group_id = module.security.rds_security_group_id
  ecr_repository_arn    = module.ecr.repository_arn
  frontend_bucket_arn   = module.s3_frontend.bucket_arn
  eks_cluster_arn       = module.eks.cluster_arn
  eks_cluster_name      = module.eks.cluster_name
  eks_cluster_sg_id     = module.eks.cluster_security_group_id

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

data "aws_route53_zone" "main" {
  name         = var.root_domain_name
  private_zone = false
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

  count = var.enable_api_alias ? 1 : 0

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.api_domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.eks_api[0].dns_name
    zone_id                = data.aws_lb.eks_api[0].zone_id
    evaluate_target_health = true
  }
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

data "aws_lb" "eks_api" {
  count = var.enable_api_alias ? 1 : 0

  tags = {
    "ingress.k8s.aws/stack" = local.api_ingress_stack
  }
}

// Parameter Prefix with fixed name for Jenkin
resource "aws_ssm_parameter" "environment_parameter_prefix" {
  name  = "/aipost-bootstrap/active"
  type  = "String"
  value = local.parameter_prefix

  description = "SSM parameter namespace used by Jenkins to discover the EKS environment."
}

resource "aws_vpc_security_group_ingress_rule" "db_from_eks" {
  security_group_id = module.security.rds_security_group_id

  referenced_security_group_id = module.eks.cluster_security_group_id

  ip_protocol = "tcp"
  from_port   = var.database_port
  to_port     = var.database_port

  description = "Allow EKS backend workloads to access PostgreSQL"
}

