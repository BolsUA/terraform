output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_policy_arn" {
  description = "The ARN of the S3 bucket policy"
  value       = aws_iam_policy.bucket_policy.arn
}