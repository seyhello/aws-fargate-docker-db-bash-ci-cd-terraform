# Create service data file
data "template_file" "service_data" {
  template = file("./service_template.json")

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
  execution_role_arn       = var.ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.service_data.rendered
}

# Service definition
resource "aws_ecs_service" "service" {
  name            = "svc_${var.vpc_name}_${var.app_name}"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.sg.id]
    subnets          = var.subnets_id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tg.id
    container_name   = var.app_name
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = "role_${var.vpc_name}_ECSTaskExecution"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
