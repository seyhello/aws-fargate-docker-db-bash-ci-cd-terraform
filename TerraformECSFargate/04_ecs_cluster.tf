# Create main ECS cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = "cluster_${var.vpc_name}"
}

# ECS task execution role data
data "aws_iam_policy_document" "role_data" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "role_${var.vpc_name}_ECSTaskExecution"
  assume_role_policy = data.aws_iam_policy_document.role_data.json
}
