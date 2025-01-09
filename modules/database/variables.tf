variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS instances will be created"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS subnet group"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to connect to RDS"
}

variable "scholarships_db_name" {
  type        = string
  description = "Name of the scholarships RDS database instance"
}

variable "scholarships_db_username" {
  type        = string
  description = "Username for the scholarships RDS instance"
  sensitive   = true
}

variable "scholarships_db_password" {
  type        = string
  description = "Password for the scholarships RDS instance"
  sensitive   = true
}

variable "applications_db_name" {
  type        = string
  description = "Name of the applications RDS database instance"
}

variable "applications_db_username" {
  type        = string
  description = "Username for the applications RDS instance"
  sensitive   = true
}

variable "applications_db_password" {
  type        = string
  description = "Password for the applications RDS instance"
  sensitive   = true
}

variable "grading_selection_db_name" {
  type        = string
  description = "Name of the grading and selection RDS database instance"
}

variable "grading_selection_db_username" {
  type        = string
  description = "Username for the grading and selection RDS instance"
  sensitive   = true
}

variable "grading_selection_db_password" {
  type        = string
  description = "Password for the grading and selection RDS instance"
  sensitive   = true
}