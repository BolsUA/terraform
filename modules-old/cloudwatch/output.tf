output "cloudwatch_logs_arn" {
  description = "The ARN of the CloudWatch Logs policy"
  value       = aws_iam_policy.cloudwatch_logs.arn
}

output "cloudwatch_frontend_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the Frontend service"
  value       = aws_cloudwatch_log_group.frontend.arn
}

output "cloudwatch_scholarships_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the Scholarships service"
  value       = aws_cloudwatch_log_group.scholarships.arn
}

output "cloudwatch_api_gateway_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the API Gateway"
  value       = aws_cloudwatch_log_group.api_gateway.arn
}