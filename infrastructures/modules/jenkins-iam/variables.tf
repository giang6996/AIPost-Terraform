variable "name_prefix" {
  description = "Prefix used for Jenkins IAM resources."
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the AIPost backend ECR repository."
  type        = string
}

variable "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket Jenkins deploys to."
  type        = string
}

variable "backend_image_tag_parameter_arn" {
  description = "ARN of the backend IMAGE_TAG deployment parameter."
  type        = string
}

variable "backend_asg_arn" {
  type = string
}
variable "database_url_parameter_arn" {
  description = "ARN of the RDS database url parameter"
  type = string
}

variable "common_tags" {
  description = "Common tags applied to Jenkins resources."
  type        = map(string)
  default     = {}
}