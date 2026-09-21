variable "name_prefix" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "backend_asg_name" {
  type = string
}

variable "rds_instance_id"{
    type        = string
}