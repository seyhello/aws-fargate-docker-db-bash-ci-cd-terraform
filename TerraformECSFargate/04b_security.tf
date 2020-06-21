# Traffic to the ECS service
resource "aws_security_group" "sg" {
  name        = "sg_${var.vpc_name}_${var.app_name}"
  description = "allow inbound access only from load balancer"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
    /*cidr_blocks = ["0.0.0.0/0"]*/
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer Security Group
resource "aws_security_group" "lb" {
  name        = "sg_lb_${var.vpc_name}_${var.app_name}"
  description = "allow inbound access from all"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
