variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "region" {
  type        = string
  description = "AWS region"
}

# Callback URLs
variable "callback_urls" {
  type        = list(string)
  description = "Callback URLs for the Cognito User Pool Client"
  default     = ["https://bolsua.pt/api/auth/callback/cognito", "http://localhost:3000/api/auth/callback/cognito"]
}

# Logout URLs
variable "logout_urls" {
  type        = list(string)
  description = "Logout URLs for the Cognito User Pool Client"
  default     = ["https://bolsua.pt", "http://localhost:3000"]
}