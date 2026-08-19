variable "name_prefix" {
    description = "Common resource naming prefix."
    type        = string
}

variable "cluster_name" {
    description = "EKS cluster name"
    type        = string
}

variable "namespace" {
    type    = string
}

variable "service_account" {
    type    = string
}

variable "media_bucket_arn"{
    description = "Public base URL used for media."
    type        = string
}

variable "parameter_arns" {
  description = "Parameter Store ARNs the backend may retrieve."
  type        = list(string)

  validation {
    condition     = length(var.parameter_arns) > 0
    error_message = "At least one Parameter Store ARN must be supplied."
  }
}

variable "common_tags" {
    type    = map(string)
    default = {}
}