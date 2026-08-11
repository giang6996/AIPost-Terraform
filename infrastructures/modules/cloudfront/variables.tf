variable "name_prefix" {
  description = "Prefix used for CloudFront resources."
  type        = string
}

variable "frontend_bucket_regional_domain_name" {
  description = "Regional domain name of the private frontend S3 bucket."
  type        = string
}

variable "frontend_domain_name" {
  description = "Custom frontend domain."
  type        = string
}

variable "frontend_certificate_arn" {
  description = "Validated ACM certificate ARN in us-east-1."
  type        = string
}

variable "frontend_bucket_arn" {
  type = string
}

variable "frontend_bucket_id" {
  type = string
}

variable "enable_distribution" {
  description = "Whether to create the CloudFront distribution and its S3 access policy."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common architecture tags."
  type        = map(string)
  default     = {}
}