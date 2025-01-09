# CloudWatch Logs Policy
resource "aws_iam_policy" "cloudwatch_logs" {
  name = "${var.app_name}-cloudwatch-logs-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/${var.app_name}-*-${var.environment}:*:*"
        ]
      }
    ]
  })
}

# Add data source to get AWS account ID
data "aws_caller_identity" "current" {}

# Frontend CloudWatch Log Group
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.app_name}-frontend-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-frontend-logs"
    Environment = var.environment
  }
}

# Scholarships Backend Service CloudWatch Log Group
resource "aws_cloudwatch_log_group" "scholarships_backend" {
  name              = "/ecs/${var.app_name}-scholarships-backend-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-scholarships-backend-logs"
    Environment = var.environment
  }
}

# Applications Backend Service CloudWatch Log Group
resource "aws_cloudwatch_log_group" "applications_backend" {
  name              = "/ecs/${var.app_name}-applications-backend-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-applications-backend-logs"
    Environment = var.environment
  }
}

# Grading and Selection Backend Service CloudWatch Log Group
resource "aws_cloudwatch_log_group" "grading_selection_backend" {
  name              = "/ecs/${var.app_name}-grading-selection-backend-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-grading-selection-backend-logs"
    Environment = var.environment
  }
}

# API Gateway CloudWatch Log Group
resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/api-gateway/${var.app_name}-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "${var.app_name}-api-gw-logs"
    Environment = var.environment
  }
}