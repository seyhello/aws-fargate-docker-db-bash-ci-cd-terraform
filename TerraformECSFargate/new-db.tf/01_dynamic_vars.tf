# Variables for environment - user prompted during execution
variable "vpc_name" {
  description = "Project name"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
variable "database_id" {
  type        = string
  description = "Database ID"
}
variable "database_name" {
  type        = string
  description = "Dtabase name"
}
variable "database_username" {
  type        = string
  description = "Database user"
}
variable "database_password" {
  type        = string
  description = "Database user password"
}
variable "subnets_id" {
  description = "Subnets ID"
}
