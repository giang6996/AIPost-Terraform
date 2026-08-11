variable "name_prefix" {
  type = string
}

variable "ami_id" {
  description = "AMI used for backend EC2 instances."
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "backend_security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "container_image_tag" {
  type    = string
  default = "latest"
}

variable "aws_region" {
  type = string
}

variable "backend_port" {
  type    = number
  default = 3000
}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

# Additional config variable for user data
variable "cors_origins" {
  description = "Comma-separated frontend origins allowed by the backend."
  type        = string
}

variable "media_storage_provider" {
  description = "Backend media storage provider."
  type        = string
  default     = "s3"
}

variable "media_public_base_url" {
  description = "Public base URL used for media."
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket used for backend media."
  type        = string
}

variable "ssm_parameter_prefix" {
  description = "SSM path prefix used by the backend."
  type        = string
}