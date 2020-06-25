# Security group
resource "aws_security_group" "sgpostgresql" {
  name        = "sg_${var.vpc_name}_${var.database_id}"
  description = "allow inbound access only from the local subnet"
  vpc_id      = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = var.database_port
    to_port   = var.database_port
    # I know, this is not secure, but for testing only
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_${var.vpc_name}_${var.database_id}"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "dbsg_${var.vpc_name}_${var.database_id}"
  subnet_ids = var.subnets_id

  tags = {
    Name = "dbsg_${var.vpc_name}_${var.database_id}"
  }
}

# RDS resources
resource "aws_db_instance" "postgresql" {
  engine                 = "postgres"
  identifier             = var.database_id
  name                   = var.database_name
  password               = var.database_password
  username               = var.database_username
  port                   = var.database_port
  vpc_security_group_ids = [aws_security_group.sgpostgresql.id]

  instance_class                  = "db.t3.micro"
  allocated_storage               = 32
  max_allocated_storage           = 100
  db_subnet_group_name            = aws_db_subnet_group.default.name
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  # Just for testing purposes
  publicly_accessible = true

  tags = {
    Name = "${var.vpc_name}_${var.database_id}"
  }
}
