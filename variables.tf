variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "Application name"
  default     = "bolsua"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
  default     = "dev"
}

# Database variables

variable "people_db_name" {
  type        = string
  description = "Name of the people RDS database instance"
  default     = "people"
}

variable "people_db_username" {
  type        = string
  description = "Username for the people RDS instance"
  sensitive   = true
  default     = "people_user"
}

variable "people_db_password" {
  type        = string
  description = "Password for the people RDS instance"
  sensitive   = true
  default     = "people_password"
}

variable "scholarships_db_name" {
  type        = string
  description = "Name of the scholarships RDS database instance"
  default     = "scholarships"
}

variable "scholarships_db_username" {
  type        = string
  description = "Username for the scholarships RDS instance"
  sensitive   = true
  default     = "scholarships_user"
}

variable "scholarships_db_password" {
  type        = string
  description = "Password for the scholarships RDS instance"
  sensitive   = true
  default     = "scholarships_password"
}

variable "applications_db_name" {
  type        = string
  description = "Name of the applications RDS database instance"
  default     = "applications"
}

variable "applications_db_username" {
  type        = string
  description = "Username for the applications RDS instance"
  sensitive   = true
  default     = "applications_user"
}

variable "applications_db_password" {
  type        = string
  description = "Password for the applications RDS instance"
  sensitive   = true
  default     = "applications_password"
}

variable "grading_selection_db_name" {
  type        = string
  description = "Name of the grading and selection RDS database instance"
  default     = "grading_selection"
}

variable "grading_selection_db_username" {
  type        = string
  description = "Username for the grading and selection RDS instance"
  sensitive   = true
  default     = "grading_selection_user"
}

variable "grading_selection_db_password" {
  type        = string
  description = "Password for the grading and selection RDS instance"
  sensitive   = true
  default     = "grading_selection_password"
}