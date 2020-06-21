# Set up CloudWatch group and log stream for the service
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "log_${var.vpc_name}_${var.app_name}"
  retention_in_days = 14

  tags = {
    Name = "log_${var.vpc_name}_${var.app_name}"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "log_stream_${var.vpc_name}_${var.app_name}"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
