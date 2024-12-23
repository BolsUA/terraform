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
  description = "VPC ID where the ALB security group will be created"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the internal ALB"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate"
}

variable "frontend_port" {
  type        = number
  description = "Frontend port for the ALB"
  default     = 80
}

variable "people_backend_port" {
  type        = number
  description = "People backend port for the ALB"
}

variable "scholarships_backend_port" {
  type        = number
  description = "Scholarships backend port for the ALB"
}

variable "applications_backend_port" {
  type        = number
  description = "Applications backend port for the ALB"
}

variable "grading_selection_backend_port" {
  type        = number
  description = "Grading and selection backend port for the ALB"
}