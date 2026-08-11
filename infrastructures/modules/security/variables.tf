variable "name_prefix" {
  description = "Prefix used to name security groups."
  type        = string

  validation {
    condition     = length(trimspace(var.name_prefix)) > 0
    error_message = "name_prefix must not be empty."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the security groups are created."
  type        = string
}

variable "backend_port" {
  description = "TCP port exposed by the AIPost backend application."
  type        = number
  default     = 3000

  validation {
    condition     = var.backend_port >= 1 && var.backend_port <= 65535
    error_message = "backend_port must be between 1 and 65535."
  }
}

variable "database_port" {
  description = "TCP port used by PostgreSQL."
  type        = number
  default     = 5432

  validation {
    condition     = var.database_port >= 1 && var.database_port <= 65535
    error_message = "database_port must be between 1 and 65535."
  }
}

variable "common_tags" {
  description = "Common tags applied to security resources."
  type        = map(string)
  default     = {}
}