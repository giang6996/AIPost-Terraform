variable "parameter_prefix" {
  description = "Hierarchical Parameter Store path used by the backend."
  type        = string

  validation {
    condition     = startswith(var.parameter_prefix, "/")
    error_message = "parameter_prefix must begin with '/'."
  }
}

variable "parameter_frontend_prefix" {
  description = "Hierarchical Parameter Store path used by the frontend."
  type        = string

  validation {
    condition     = startswith(var.parameter_frontend_prefix, "/")
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

variable "s3_frontend_bucket" {
  description = "Front-end S3 bucket name used by AIPost Static Vue Application."
  type        = string
}

# This is not considered a secret, but for best practice must still apply sensitive
variable "frontend_tinymce_api_key" {
  description = "TinyMCE API key injected into the AIPost frontend during the Vite build."
  type        = string
  sensitive   = true
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