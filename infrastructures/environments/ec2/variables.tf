variable "aws_profile" {
  description = "AWS IAM profile in which the personal EC2 architecture is deployed."
  type        = string
  default     = "personal"

  validation {
    condition     = length(trimspace(var.aws_profile)) > 0
    error_message = "aws_profile must not be empty."
  }
}

variable "aws_region" {
  description = "AWS region in which the personal EC2 architecture is deployed."
  type        = string
  default     = "ap-southeast-1"

  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region must not be empty."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the AIPost VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Two Availability Zones used by the AIPost architecture."
  type        = list(string)

  default = [
    "ap-southeast-1a",
    "ap-southeast-1b"
  ]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones must be provided."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs must be provided."
  }
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets."
  type        = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  validation {
    condition     = length(var.private_app_subnet_cidrs) == 2
    error_message = "Exactly two private application subnet CIDRs must be provided."
  }
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets."
  type        = list(string)

  default = [
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]

  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "Exactly two private database subnet CIDRs must be provided."
  }
}

variable "nat_mode" {
  description = "Controls whether the VPC uses one shared NAT Gateway or one NAT Gateway per Availability Zone."
  type        = string
  default     = "single"

  validation {
    condition = contains(
      ["single", "per_az"],
      var.nat_mode
    )

    error_message = "nat_mode must be either \"single\" or \"per_az\"."
  }
}

variable "ssm_parameter_prefix" {
  description = "Hierarchical Parameter Store path used by the backend."
  type        = string

  validation {
    condition     = startswith(var.ssm_parameter_prefix, "/")
    error_message = "parameter_prefix must begin with '/'."
  }
}

variable "frontend_tinymce_api_key" {
  description = "Front-end S3 bucket name used by AIPost Static Vue Application."
  type        = string
}

variable "backend_port" {
  description = "Port exposed by the AIPost Node.js backend."
  type        = number
  default     = 3000
}

variable "cors_origins" {
  description = "CORS origins allowed by the backend."
  type        = string
  default     = "http://localhost:5173"
}

variable "media_public_base_url" {
  description = "Public media base URL."
  type        = string
  default     = ""
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

variable "retention_days" {
  description = "CloudWatch log event retention duration measure in days"
  type        = number
  default     = 7
}

variable "backend_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "backend_image_tag" {
  type    = string
  default = "demo"
}

variable "asg_min_size" {
  type    = number
  default = 0
}

variable "asg_desired_capacity" {
  type    = number
  default = 0
}

variable "asg_max_size" {
  type    = number
  default = 2
}


variable "initial_backend_image_tag" {
  description = "Initial AIPost Docker image tag"
  type        = string
  default     = "latest"
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


# Debug
# CloudFront
variable "enable_cloudfront" {
  description = "Whether to deploy the CloudFront frontend distribution and related integration resources."
  type        = bool
  default     = false
}

variable "jenkins_instance_type" {
  description = "EC2 instance type used by Jenkins."
  type        = string
  default     = "t3.small"
}