# Output information
output "service_dns_hostname" {
  description = "DNS name for the deployed service"
  value       = aws_alb.main_lb.dns_name
}
