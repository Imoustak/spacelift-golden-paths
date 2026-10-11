variable "service_name" {
  type        = string
  description = "Owning service, lowercase letters, digits and hyphens"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,40}$", var.service_name))
    error_message = "service_name must start with a letter and use only lowercase letters, digits, and hyphens (max 41 chars)."
  }
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "size" {
  type    = string
  default = "small"

  validation {
    condition     = contains(["small", "medium", "large"], var.size)
    error_message = "size must be small, medium, or large."
  }
}

variable "owner_team" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC to place the database in. Supplied by the aws-network-<env> context."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnets for the DB subnet group. Supplied by the aws-network-<env> context."
}
