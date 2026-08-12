# Create ALB SG
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Controls traffic to and from the AIPost Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb-sg"
      Tier = "load-balancer"
    }
  )
}

# Create Backend Instance SG
resource "aws_security_group" "backend" {
  name        = "${var.name_prefix}-backend-sg"
  description = "Controls traffic to and from AIPost backend workloads"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-backend-sg"
      Tier = "application"
    }
  )
}

# Create RDS db Instance SG
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Controls traffic to and from AIPost PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-rds-sg"
      Tier = "database"
    }
  )
}

# Inbound HTTP for ALB
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow public HTTP traffic"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
}

# Inbound HTTPS for ALB
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow public HTTPS traffic"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ipv4   = "0.0.0.0/0"
}

# Outbound all traffic to backend SG
resource "aws_vpc_security_group_egress_rule" "alb_to_backend" {
  security_group_id = aws_security_group.alb.id

  description                  = "Allow ALB traffic to the AIPost backend"
  ip_protocol                  = "tcp"
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  referenced_security_group_id = aws_security_group.backend.id
}

# Inbound backend SG from ALB SG
resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id = aws_security_group.backend.id

  description                  = "Allow backend traffic only from the ALB"
  ip_protocol                  = "tcp"
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "backend_all_outbound" {
  security_group_id = aws_security_group.backend.id

  description = "Allow backend workloads to reach required internal and external services"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_backend" {
  security_group_id = aws_security_group.rds.id

  description                  = "Allow PostgreSQL connections from AIPost backend workloads"
  ip_protocol                  = "tcp"
  from_port                    = var.database_port
  to_port                      = var.database_port
  referenced_security_group_id = aws_security_group.backend.id
}

resource "aws_vpc_security_group_egress_rule" "rds_all_outbound" {
  security_group_id = aws_security_group.rds.id

  description = "Allow database response and AWS-managed outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_jenkins" {
  security_group_id = aws_security_group.rds.id

  referenced_security_group_id = aws_security_group.jenkins.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "Allow Jenkins CI/CD migration runner to access PostgreSQL"
}


resource "aws_security_group" "jenkins" {
  name        = "${var.name_prefix}-jenkins-sg"
  description = "Security group for Jenkins CI/CD controller"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-jenkins-sg"
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