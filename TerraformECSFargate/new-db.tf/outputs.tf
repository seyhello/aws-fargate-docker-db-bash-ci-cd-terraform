output "hostname" {
  value       = aws_db_instance.postgresql.address
  description = "Public DNS name of the database instance"
}
