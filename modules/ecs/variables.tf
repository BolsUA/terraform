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

# VPC ID
variable "vpc_id" {
  type        = string
  description = "VPC ID where the ECS security group will be created"
}

# ALB Security Group ID
variable "alb_security_group_id" {
  type        = string
  description = "ALB security group ID"
}

# Internal ALB Security Group ID
variable "internal_alb_security_group_id" {
  type        = string
  description = "Internal ALB security group ID"
}

# Private subnet IDs
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the ECS service"
}

# CloudWatch Logs ARN
variable "cloudwatch_logs" {
  type        = string
  description = "CloudWatch Logs ARN"
}

# S3 Bucket Policy ARN
variable "s3_bucket_policy_arn" {
  type        = string
  description = "S3 Bucket Policy ARN"
}

# SQS Policy ARN
variable "sqs_policy_arn" {
  type        = string
  description = "SQS Policy ARN"
}

# Frontend variables
variable "frontend_repository_url" {
  type        = string
  description = "ECR Repository URL for the frontend"
}

variable "frontend_port" {
  type        = number
  description = "Frontend port for the ECS service"
  default     = 80
}

variable "auth_secret" {
  type        = string
  description = "Next.js Auth secret"
}

variable "auth_cognito_client_id" {
  type        = string
  description = "Cognito User Pool Client ID"
}

variable "auth_cognito_user_pool_id" {
  type        = string
  description = "Cognito User Pool ID"
}

variable "auth_cognito_secret" {
  type        = string
  description = "Cognito User Pool Client Secret"
}

variable "auth_cognito_issuer" {
  type        = string
  description = "Cognito User Pool Issuer"
}

variable "frontend_target_group_arn" {
  type        = string
  description = "Frontend target group ARN"
}

# Scholarships backend variables
variable "scholarships_backend_repository_url" {
  type        = string
  description = "ECR Repository URL for the scholarships backend"
}

variable "scholarships_backend_port" {
  type        = number
  description = "Scholarships backend port for the ECS service"
}

variable "scholarships_db_connection_string" {
  type        = string
  description = "Scholarships RDS connection string"
}

variable "scholarships_backend_target_group_arn" {
  type        = string
  description = "Scholarships backend target group ARN"
}