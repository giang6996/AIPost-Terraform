variable "name_prefix" {
  description = "Prefix used for Jenkins IAM resources."
  type        = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "frontend_bucket_arn" {
  type = string
}

variable "database_url_parameter_arn" {
  type = string
}

variable "backend_asg_arn" {
  type     = string
  default  = null
  nullable = true
}

variable "initial_backend_image_tag_parameter_arn" {
  type     = string
  default  = null
  nullable = true
}

variable "eks_cluster_arn" {
  type     = string
  default  = null
  nullable = true
}

variable "netlify_site_id_parameter_arn" {
  type    = string
  default = null
}

variable "netlify_auth_token_parameter_arn" {
  type      = string
  default   = null
  sensitive = true
}

variable "common_tags" {
  description = "Common tags applied to Jenkins resources."
  type        = map(string)
  default     = {}
}