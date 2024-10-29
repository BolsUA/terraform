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
