data "aws_ssm_parameter" "vpc_id" {
  name = "${local.environment_prefix}/VPC_ID"
}

data "aws_ssm_parameter" "jenkins_subnet_id" {
  name = "${local.environment_prefix}/JENKINS_SUBNET_ID"
}

data "aws_ssm_parameter" "database_port" {
  name = "${local.environment_prefix}/DATABASE_PORT"
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

  referenced_security_group_id = aws_security_group.rds.id

  ip_protocol = "tcp"
  from_port   = data.aws_ssm_parameter.database_port.value
  to_port     = data.aws_ssm_parameter.database_port.value
}