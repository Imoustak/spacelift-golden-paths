terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Region and credentials come from the aws-network-<env> context and the AWS integration.
provider "aws" {}

variable "service_name" { type = string }
variable "environment" { type = string }
variable "size" { type = string }
variable "owner_team" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }

module "postgres" {
  source  = "spacelift.io/imoustak/rds-postgres/aws"
  version = "~> 1.0"

  service_name = var.service_name
  environment  = var.environment
  size         = var.size
  owner_team   = var.owner_team
  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
}

output "endpoint" {
  value = module.postgres.endpoint
}

output "db_name" {
  value = module.postgres.db_name
}

output "master_user_secret_arn" {
  value = module.postgres.master_user_secret_arn
}

output "security_group_id" {
  value = module.postgres.security_group_id
}
