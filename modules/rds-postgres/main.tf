locals {
  is_prod = var.environment == "prod"
  name    = "${var.service_name}-${var.environment}"
  instance_class = {
    small  = "db.t4g.medium"
    medium = "db.r7g.large"
    large  = "db.r7g.2xlarge"
  }[var.size]

  tags = {
    Service     = var.service_name
    Environment = var.environment
    Owner       = var.owner_team
    ManagedBy   = "golden-path/rds-postgres"
  }
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_db_subnet_group" "this" {
  name       = local.name
  subnet_ids = var.subnet_ids
  tags       = local.tags
}

resource "aws_security_group" "db" {
  name        = "${local.name}-postgres"
  description = "Postgres access for ${var.service_name} (${var.environment})"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "postgres" {
  security_group_id = aws_security_group.db.id
  description       = "Postgres from inside the VPC"
  cidr_ipv4         = data.aws_vpc.this.cidr_block
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

resource "aws_db_instance" "this" {
  identifier     = local.name
  engine         = "postgres"
  engine_version = "17"
  instance_class = local.instance_class
  db_name        = replace(var.service_name, "-", "_")
  username       = "app_admin"

  allocated_storage     = 50
  max_allocated_storage = 500
  storage_type          = "gp3"
  # Encrypted with the AWS-managed aws/rds key. Pass a customer-managed key via kms_key_id if your org requires one.
  storage_encrypted = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false

  multi_az                            = local.is_prod
  backup_retention_period             = local.is_prod ? 30 : 7
  deletion_protection                 = local.is_prod
  skip_final_snapshot                 = !local.is_prod
  final_snapshot_identifier           = local.is_prod ? "${local.name}-final" : null
  copy_tags_to_snapshot               = true
  auto_minor_version_upgrade          = true
  apply_immediately                   = !local.is_prod
  manage_master_user_password         = true
  iam_database_authentication_enabled = true

  tags = local.tags
}
