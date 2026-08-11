variable "name_prefix" {
  description = "Prefix used when naming networking resources."
  type        = string

  validation {
    condition     = length(trimspace(var.name_prefix)) > 0
    error_message = "name_prefix must not be empty."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used for the subnet layers."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "The networking module requires exactly two Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks assigned to public subnets."
  type        = list(string)

  validation {
    condition = (
      length(var.public_subnet_cidrs) ==
      length(var.availability_zones)
    )
    error_message = "One public subnet CIDR must be supplied for each Availability Zone."
  }
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks assigned to private application subnets."
  type        = list(string)

  validation {
    condition = (
      length(var.private_app_subnet_cidrs) ==
      length(var.availability_zones)
    )
    error_message = "One private application subnet CIDR must be supplied for each Availability Zone."
  }
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks assigned to private database subnets."
  type        = list(string)

  validation {
    condition = (
      length(var.private_db_subnet_cidrs) ==
      length(var.availability_zones)
    )
    error_message = "One private database subnet CIDR must be supplied for each Availability Zone."
  }
}

variable "common_tags" {
  description = "Common tags applied to networking resources."
  type        = map(string)
  default     = {}
}

variable "nat_mode" {
  description = "Controls whether the network uses one shared NAT Gateway or one NAT Gateway per Availability Zone, depend on running enviroment"
  type        = string
  default     = "single"

  validation {
    condition = contains(
      ["single", "per_az"],
      var.nat_mode
    )

    error_message = "nat_mode must be either single or per_az."
  }
}
