output "cloudwatch_policy_arn" {
  description = "The ARN of the CloudWatch Logs policy"
  value       = aws_iam_policy.cloudwatch_policy.arn
}

output "cloudwatch_frontend_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the Frontend service"
  value       = aws_cloudwatch_log_group.frontend.arn
}

output "cloudwatch_scholarships_backend_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the Scholarships Backend service"
  value       = aws_cloudwatch_log_group.scholarships_backend.arn
}

output "cloudwatch_applications_backend_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the Applications Backend service"
  value       = aws_cloudwatch_log_group.applications_backend.arn
}

output "cloudwatch_grading_selection_backend_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the Grading and Selection Backend service"
  value       = aws_cloudwatch_log_group.grading_selection_backend.arn
}

output "cloudwatch_api_gateway_log_group_arn" {
  description = "The arn of the CloudWatch Log Group for the API Gateway"
  value       = aws_cloudwatch_log_group.api_gateway.arn
}