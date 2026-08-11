variable "bucket_name" {
  description = "Globally unique frontend bucket name."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to frontend storage resources."
  type        = map(string)
  default     = {}
}