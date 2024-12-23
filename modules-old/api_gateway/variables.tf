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

# Allowed Origins
variable "allowed_origins" {
  type        = list(string)
  description = "List of allowed origins for CORS"
  default     = ["https://bolsua.pt"]
}

# CloudWatch API Gateway Log Group ARN
variable "cloudwatch_api_gateway_log_group_arn" {
  type        = string
  description = "The arn of the CloudWatch Log Group for the API Gateway"
}

# ALB Security Group ID
variable "alb_security_group_id" {
  type        = string
  description = "ALB security group ID"
}

variable "alb_https_listener_arn" {
  type        = string
  description = "The ARN of the HTTPS listener"
}

# Private subnet IDs
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the ECS service"
}

# Cognito Variables
variable "cognito_client_id" {
  type        = string
  description = "The ID of the Cognito User Pool Client"
}

variable "cognito_user_pool_issuer" {
  type        = string
  description = "The issuer of the Cognito User Pool"
}
