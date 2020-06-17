resource "aws_security_group" "sghirevolgy" {
  name        = "sghirevolgy"
  description = "Security group that allows inbound and outbound traffic from all"
  /* SSH from All is not secure but this is only for demonstration purposes */

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*resource "aws_key_pair" "kphirevolgy" {
  key_name   = "KeyPair"
  public_key = file("KeyPairOut.pub")
}*/
