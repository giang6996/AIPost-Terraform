variable "name_prefix" {
  description = "Prefix used for ECR resources."
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether an existing Docker tag may be overwritten."
  type        = string
  default     = "MUTABLE"

  validation {
    condition = contains(
      ["MUTABLE", "IMMUTABLE"],
      var.image_tag_mutability
    )

    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "common_tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}

variable "manage_ecr" {
  type    = bool
  default = true
}