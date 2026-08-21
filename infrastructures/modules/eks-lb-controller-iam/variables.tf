variable "name_prefix" {
    description = "Common resource naming prefix."
    type        = string
}

variable "cluster_name" {
    description = "EKS cluster name"
    type        = string
}

variable "common_tags" {
    type    = map(string)
    default = {}
}