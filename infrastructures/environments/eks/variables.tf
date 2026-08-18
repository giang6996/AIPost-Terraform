variable "aws_region" {
  description = "AWS region for the EKS environment."
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS CLI profile used by Terraform locally."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the AIPost VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by the environment."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDRs for private application/EKS node subnets."
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDRs for private database subnets."
  type        = list(string)
}

variable "nat_mode" {
  description = "NAT deployment mode: single for demo or per_az for production."
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "eks_node_instance_types" {
  description = "EC2 instance types used by the EKS managed node group."
  type        = list(string)
}

variable "eks_node_min_size" {
  description = "Minimum worker node count."
  type        = number
}

variable "eks_node_desired_size" {
  description = "Desired worker node count."
  type        = number
}

variable "eks_node_max_size" {
  description = "Maximum worker node count."
  type        = number
}