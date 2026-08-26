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

variable "target_environment" {
  description = "Active AIPost environment Jenkins will manage."

  type = string

  validation {
    condition = contains(
      ["ec2", "eks"],
      var.target_environment
    )

    error_message = "target_environment must be either ec2 or eks."
  }
}

variable "jenkins_instance_type" {
  description = "EC2 instance type used by Jenkins."
  type        = string
  default     = "t3.small"
}

variable "kms_key_id" {
  description = "Optional KMS key ID or ARN for SecureString encryption. Null uses the AWS-managed SSM key."
  type        = string
  default     = null
}

variable "enable_netlify" {
  type    = bool
  default = false
}

variable "netlify_auth_token" {
  type        = string
  sensitive   = true
}

variable "netlify_site_id" {
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags applied to Jenkins resources."
  type        = map(string)
  default     = {}
}