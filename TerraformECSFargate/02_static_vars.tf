#AWS basic parameters

variable "aws_region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

provider "aws" {
  region  = var.aws_region
}

variable "health_check_path" {
  default = "/"
}
