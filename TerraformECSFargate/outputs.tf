# Output information
output "cluster_id" {
  description = "ECS Cluster ID used for adding more services to the same cluster"
  value       = aws_ecs_cluster.main_cluster.id
}

output "vpc_id" {
  description = "VPC ID used for adding more services to the same cluster"
  value       = aws_vpc.main_vpc.id
}

output "ecs_execution_role_arn" {
  value       = aws_iam_role.ecs_task_execution_role.arn
  description = "ECS execution role ARN used for adding more services to the same cluster"
}

output "subnets_id" {
  value       = aws_subnet.public.*.id
  description = "ECS subnets ID used for adding more services to the same cluster"
}

output "zz_dns_hostname" {
  description = "DNS name for the deployed service"
  value       = aws_alb.main_lb.dns_name
}
