# Scholarships to Applications Queue
output "scholarships_applications_queue_url" {
  description = "The URL of the Scholarships to Applications queue"
  value       = aws_sqs_queue.scholarships_applications.url
}

output "scholarships_applications_queue_arn" {
  description = "The ARN of the Scholarships to Applications queue"
  value       = aws_sqs_queue.scholarships_applications.arn
}

output "scholarships_applications_dlq_url" {
  description = "The URL of the Scholarships to Applications DLQ"
  value       = var.enable_dlq ? aws_sqs_queue.scholarships_applications_dlq[0].url : null
}

output "scholarships_applications_dlq_arn" {
  description = "The ARN of the Scholarships to Applications DLQ"
  value       = var.enable_dlq ? aws_sqs_queue.scholarships_applications_dlq[0].arn : null
}

# Applications to Grading Queue
output "applications_grading_queue_url" {
  description = "The URL of the Applications to Grading queue"
  value       = aws_sqs_queue.applications_grading.url
}

output "applications_grading_queue_arn" {
  description = "The ARN of the Applications to Grading queue"
  value       = aws_sqs_queue.applications_grading.arn
}

output "applications_grading_dlq_url" {
  description = "The URL of the Applications to Grading DLQ"
  value       = var.enable_dlq ? aws_sqs_queue.applications_grading_dlq[0].url : null
}

output "applications_grading_dlq_arn" {
  description = "The ARN of the Applications to Grading DLQ"
  value       = var.enable_dlq ? aws_sqs_queue.applications_grading_dlq[0].arn : null
}

# Grading to Applications Queue
output "grading_applications_queue_url" {
  description = "The URL of the Grading to Applications queue"
  value       = aws_sqs_queue.grading_applications.url
}

output "grading_applications_queue_arn" {
  description = "The ARN of the Grading to Applications queue"
  value       = aws_sqs_queue.grading_applications.arn
}

output "grading_applications_dlq_url" {
  description = "The URL of the Grading to Applications DLQ"
  value       = var.enable_dlq ? aws_sqs_queue.grading_applications_dlq[0].url : null
}

output "grading_applications_dlq_arn" {
  description = "The ARN of the Grading to Applications DLQ"
  value       = var.enable_dlq ? aws_sqs_queue.grading_applications_dlq[0].arn : null
}

# IAM User credentials for the queue
output "queue_access_key_id" {
  description = "The access key ID for the IAM user for the queue"
  value       = aws_iam_access_key.queue_user.id
}

output "queue_secret_access_key" {
  description = "The secret access key for the IAM user for the queue"
  value       = aws_iam_access_key.queue_user.secret
  sensitive   = true
}