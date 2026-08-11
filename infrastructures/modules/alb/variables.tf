variable "name_prefix" {
  description = "Prefix name for ALB"
  type        = string
}

variable "vpc_id" {
  description = "Targeted VPC for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet for the ALB to operate"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group for ALB"
  type        = string
}

variable "backend_port" {
  description = "Inbound Port Number"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Health check path to check backend instance"
  type        = string
  default     = "/health"
}

variable "certificate_arn" {
  description = "ACM certificate used by the HTTPS listener."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to ALB."
  type        = map(string)
  default     = {}
}