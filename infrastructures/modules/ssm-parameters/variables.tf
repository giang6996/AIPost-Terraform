variable "parameter_api_prefix" {
  description = "Hierarchical Parameter Store API path used by the backend."
  type        = string

  validation {
    condition     = startswith(var.parameter_api_prefix, "/")
    error_message = "parameter_prefix must begin with '/'."
  }
}

variable "parameter_frontend_prefix" {
  description = "Hierarchical Parameter Store Front-end path used by the frontend."
  type        = string

  validation {
    condition     = startswith(var.parameter_frontend_prefix, "/")
    error_message = "parameter_prefix must begin with '/'."
  }
}

variable "parameter_network_prefix" {
  description = "Hierarchical Parameter Store network-related path used by the shared network module."
  type        = string

  validation {
    condition     = startswith(var.parameter_network_prefix, "/")
    error_message = "parameter_prefix must begin with '/'."
  }
}

variable "parameter_infrastructure_prefix" {
  description = "Hierarchical Parameter Store infrastructure-related path."
  type        = string

  validation {
    condition     = startswith(var.parameter_infrastructure_prefix, "/")
    error_message = "parameter_prefix must begin with '/'."
  }
}

variable "initial_backend_image_tag" {
  description = "Initial backend Docker image tag before CI/CD takes ownership."
  type        = string
  default     = null
}

variable "database_url" {
  description = "PostgreSQL connection string consumed by the backend."
  type        = string
  sensitive   = true
}

variable "database_port" {
  description = "PostgreSQL connection port."
  type        = number
  default     = 5432
}

variable "encryption_key" {
  description = "Application-level encryption key used by AIPost."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.encryption_key) >= 32
    error_message = "encryption_key must contain at least 32 characters."
  }
}

variable "ecr_repository_url" {
  description = "ECR repository full URL for AIPost image"
  type        = string
}

variable "enable_ec2_metadata" {
  type    = bool
  default = false
}

variable "backend_asg_name" {
  description = "Auto Scalling Group for AIPost Backend Application"
  type        = string
  default     = null
}

variable "s3_frontend_bucket" {
  description = "Front-end S3 bucket name used by AIPost Static Vue Application."
  type        = string
}

variable "app_url" {
  description = "Front-end url for AIPost Static Vue Application."
  type        = string
}

variable "api_url" {
  description = "Api url for AIPost Backend Application."
  type        = string
}

# This is not considered a secret, but for best practice must still apply sensitive
variable "frontend_tinymce_api_key" {
  description = "TinyMCE API key injected into the AIPost frontend during the Vite build."
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  type = string
}

variable "jenkins_subnet_id" {
  type = string
}

variable "rds_security_group_id" {
  description = "RDS Security Group ID"
  type = string
}

variable "ecr_repository_arn"{
  type = string
}

variable "frontend_bucket_arn"{
  type = string
}

variable "backend_asg_arn"{
  type = string
  default = null
}

variable "enable_eks_metadata" {
  type    = bool
  default = false
}

variable "eks_cluster_arn"{
  type = string
  default = null
}

variable "eks_cluster_name"{
  type = string
  default = null
}

variable "eks_cluster_sg_id"{
  type = string
  default = null
}


variable "kms_key_id" {
  description = "Optional KMS key ID or ARN for SecureString encryption. Null uses the AWS-managed SSM key."
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags applied to Parameter Store resources."
  type        = map(string)
  default     = {}
}