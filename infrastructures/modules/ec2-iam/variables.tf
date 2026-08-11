variable "name_prefix" {
  description = "Prefix used to name EC2 IAM resources."
  type        = string
}

variable "media_bucket_arn" {
  description = "ARN of the AIPost media bucket."
  type        = string
}

variable "parameter_arns" {
  description = "Parameter Store ARNs the backend may retrieve."
  type        = list(string)

  validation {
    condition     = length(var.parameter_arns) > 0
    error_message = "At least one Parameter Store ARN must be supplied."
  }
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository containing the AIPost backend image."
  type        = string
}

variable "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group used by the backend."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to IAM resources."
  type        = map(string)
  default     = {}
}