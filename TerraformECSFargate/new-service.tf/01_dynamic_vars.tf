# Variables for environment - user prompted during execution
variable "vpc_name" {
  description = "Project name"
}
variable "ecs_execution_role_arn" {
  description = "ECS task execution role ARN"
}
variable "cluster_id" {
  description = "Cluster ID"
}
variable "subnets_id" {
  description = "Subnets ID"
}
variable "vpc_id" {
  description = "VPC ID"
}


# Service unique variables declared in services/<service_name>.tfvars
variable "app_name" {
  description = "Application name"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
}

variable "app_count" {
  description = "Number of docker containers to run"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
}
