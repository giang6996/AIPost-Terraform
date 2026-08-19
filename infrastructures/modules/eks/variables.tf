variable "name_prefix" {
  description = "Common resource naming prefix."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version used by the EKS cluster."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs used by EKS."
  type        = list(string)
}

variable "node_instance_types" {
  description = "EC2 instance types used by the managed node group."
  type        = list(string)
}

variable "node_desired_size" {
  type = number
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "secrets_store_provider_version" {
  description = "EKS add-on version for the AWS Secrets Store CSI provider."
  type        = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}