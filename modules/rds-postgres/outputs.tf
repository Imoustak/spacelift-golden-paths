output "endpoint" {
  description = "Connection endpoint (host:port)"
  value       = aws_db_instance.this.endpoint
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN holding the master credentials"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}

output "security_group_id" {
  description = "Attach client workloads to this group or add ingress rules to it"
  value       = aws_security_group.db.id
}
