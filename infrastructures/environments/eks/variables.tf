variable "aws_region" {
  description = "AWS region for the EKS environment."
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS CLI profile used by Terraform locally."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the AIPost VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by the environment."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDRs for private application/EKS node subnets."
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDRs for private database subnets."
  type        = list(string)
}

variable "nat_mode" {
  description = "NAT deployment mode: single for demo or per_az for production."
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "eks_node_instance_types" {
  description = "EC2 instance types used by the EKS managed node group."
  type        = list(string)
}

variable "eks_node_min_size" {
  description = "Minimum worker node count."
  type        = number
}

variable "eks_node_desired_size" {
  description = "Desired worker node count."
  type        = number
}

variable "eks_node_max_size" {
  description = "Maximum worker node count."
  type        = number
}

variable "secrets_store_provider_version" {
  description = "EKS add-on version for the AWS Secrets Store CSI provider."
  type        = string
}

variable "namespace" {
    type    = string
    default = "aipost"
}

variable "service_account" {
    type    = string
    default = "aipost-backend"
}

variable "backend_port" {
  description = "Port exposed by the AIPost Node.js backend."
  type        = number
  default     = 3000
}


variable "database_port" {
  description = "Port used by PostgreSQL."
  type        = number
  default     = 5432
}

variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "aipost"
}

variable "database_username" {
  description = "PostgreSQL administrative username."
  type        = string
  default     = "aipost_admin"
}

variable "database_password" {
  description = "PostgreSQL administrative password."
  type        = string
  sensitive   = true
}

variable "database_engine_version" {
  description = "PostgreSQL engine version."
  type        = string
}

variable "database_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "database_multi_az" {
  description = "Whether the RDS instance uses a Multi-AZ standby."
  type        = bool
  default     = false
}

variable "encryption_key" {
  description = "AIPost application encryption key."
  type        = string
  sensitive   = true
}

variable "root_domain_name" {
  description = "Root Route 53 domain."
  type        = string
  default     = "jeblearning.pro.vn"
}

variable "frontend_domain_name" {
  description = "Frontend application domain."
  type        = string
  default     = "app.jeblearning.pro.vn"
}

variable "api_domain_name" {
  description = "Backend API domain."
  type        = string
  default     = "api.jeblearning.pro.vn"
}

variable "frontend_tinymce_api_key" {
  description = "Front-end S3 bucket name used by AIPost Static Vue Application."
  type        = string
}

variable "api_ingress_namespace" {
  type    = string
  default = "aipost"
}

variable "api_ingress_name" {
  type    = string
  default = "aipost-backend"
}

variable "enable_cloudfront" {
  description = "Whether to deploy the CloudFront frontend distribution and related integration resources."
  type        = bool
  default     = false
}
