variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for the root domain."
  type        = string
}

variable "frontend_domain_name" {
  description = "Frontend hostname used by CloudFront."
  type        = string
}

variable "api_domain_name" {
  description = "Backend API hostname used by the ALB."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to supported resources."
  type        = map(string)
  default     = {}
}