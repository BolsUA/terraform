variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "domain_name" {
  type        = string
  description = "Domain name for SES identity"
  default     = "bolsua.pt"
}