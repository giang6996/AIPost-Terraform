variable "retention_days" {
  description = "Time measure in day which logs event existed"
  type        = number
  default     = 7

  validation {
    condition     = var.retention_days >= 7
    error_message = "retention value must be at least 7 days"
  }
}

variable "environment" {
  description = "Name of the environment the application is running (EC2 or Container)"
  type        = string
  default     = "ec2"
}

variable "common_tags" {
  description = "Common tags applied to CloudWatch log output."
  type        = map(string)
  default     = {}
}