variable "environment" {
  description = "Local Deploy Environment Name for backend image tag"
  type = string
}

variable "parameter_prefix" {
  description = "Hierarchical Parameter Store path used by the backend."
  type        = string

  validation {
    condition     = startswith(var.parameter_prefix, "/")
    error_message = "parameter_prefix must begin with '/'."
  }
}

variable "initial_backend_image_tag" {
  description = "Initial backend Docker image tag before CI/CD takes ownership."
  type        = string
  default     = "demo"
}

variable "database_url" {
  description = "PostgreSQL connection string consumed by the backend."
  type        = string
  sensitive   = true
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