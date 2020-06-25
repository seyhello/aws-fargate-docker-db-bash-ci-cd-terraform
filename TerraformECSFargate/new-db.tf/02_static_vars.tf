variable "aws_region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

variable "database_port" {
  default     = 5432
  type        = number
  description = "Port on which database will accept connections"
}
