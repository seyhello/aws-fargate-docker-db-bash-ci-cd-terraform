# Create main ECS cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = "cluster_${var.vpc_name}"
}

# Create service data file
data "template_file" "service_data" {
  template = file("./new-service/service_template.json")

  vars = {
    app_name       = var.app_name
    aws_region     = var.aws_region
    app_image      = var.app_image
    app_port       = var.app_port
    vpc_name       = var.vpc_name
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
  }
}

# Task definition based on defined service variables
resource "aws_ecs_task_definition" "app" {
  family                   = "task_${var.vpc_name}_${var.app_name}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.service_data.rendered
}

# Service definition
resource "aws_ecs_service" "service" {
  name            = "svc_${var.vpc_name}_${var.app_name}"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.sg.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tg.id
    container_name   = var.app_name
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
