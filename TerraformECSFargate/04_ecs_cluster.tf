# Create main ECS cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = "cluster_${var.vpc_name}"
}
