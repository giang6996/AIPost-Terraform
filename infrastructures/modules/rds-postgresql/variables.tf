variable "name_prefix" {
  description = "Prefix used when naming PostgreSQL resources."
  type        = string

  validation {
    condition     = length(trimspace(var.name_prefix)) > 0
    error_message = "name_prefix must not be empty."
  }
}

variable "db_subnet_ids" {
  description = "Private database subnet IDs used by the RDS subnet group."
  type        = list(string)

  validation {
    condition     = length(var.db_subnet_ids) >= 2
    error_message = "At least two database subnet IDs must be supplied."
  }
}

variable "rds_security_group_id" {
  description = "Security group that permits PostgreSQL traffic from backend workloads."
  type        = string
}

variable "database_name" {
  description = "Initial PostgreSQL database created for AIPost."
  type        = string
  default     = "aipost"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]*$", var.database_name))
    error_message = "database_name must begin with a letter and contain only letters, digits, or underscores."
  }
}

variable "master_username" {
  description = "PostgreSQL administrative username."
  type        = string
  default     = "aipost_admin"

  validation {
    condition     = length(trimspace(var.master_username)) > 0
    error_message = "master_username must not be empty."
  }
}

variable "master_password" {
  description = "PostgreSQL administrative password."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.master_password) >= 12
    error_message = "master_password must contain at least 12 characters."
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

variable "engine_version" {
  description = "PostgreSQL engine version. Confirm regional availability before changing."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial RDS storage size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "allocated_storage must be at least 20 GiB for this configuration."
  }
}

variable "max_allocated_storage" {
  description = "Maximum GiB to which RDS storage autoscaling may grow."
  type        = number
  default     = 50

  validation {
    condition     = var.max_allocated_storage >= var.allocated_storage
    error_message = "max_allocated_storage must not be smaller than allocated_storage."
  }
}

variable "multi_az" {
  description = "Whether RDS should maintain a synchronous standby in another Availability Zone."
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Number of days automated backups are retained."
  type        = number
  default     = 7

  validation {
    condition = (
      var.backup_retention_days >= 0 &&
      var.backup_retention_days <= 35
    )
    error_message = "backup_retention_days must be between 0 and 35."
  }
}

variable "deletion_protection" {
  description = "Prevents accidental deletion of the RDS instance."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether RDS deletion skips creation of a final snapshot."
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Whether supported modifications should be applied immediately instead of during the maintenance window."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags applied to RDS resources."
  type        = map(string)
  default     = {}
}