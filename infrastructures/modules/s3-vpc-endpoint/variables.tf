variable "name_prefix" {
  description = "Prefix used when naming the S3 VPC endpoint."
  type        = string
}

variable "aws_region" {
  description = "AWS region containing the S3 service endpoint."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC receiving the S3 gateway endpoint."
  type        = string
}

variable "route_table_ids" {
  description = "Route tables whose subnets should use the S3 gateway endpoint."
  type        = list(string)

  validation {
    condition     = length(var.route_table_ids) > 0
    error_message = "At least one route table ID must be provided."
  }
}

variable "common_tags" {
  description = "Common tags applied to the endpoint."
  type        = map(string)
  default     = {}
}