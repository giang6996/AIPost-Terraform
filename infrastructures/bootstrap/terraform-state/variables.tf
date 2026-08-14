variable "aws_region" {
  description = "AWS region used for the Terraform state bucket."
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "Local AWS CLI profile used to bootstrap Terraform state infrastructure."
  type        = string
}

variable "noncurrent_state_retention_days" {
  description = "Number of days old Terraform state versions are retained."
  type        = number
  default     = 30
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket used to store Terraform remote state."
  type        = string
}