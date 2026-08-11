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

variable "common_tags" {
  description = "Common tags applied to Jenkins resources."
  type        = map(string)
  default     = {}
}