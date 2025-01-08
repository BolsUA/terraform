output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "s3_bucket_access_key_id" {
  description = "The access key ID for the IAM user for the S3 bucket"
  value       = aws_iam_access_key.bucket_user.id
}

output "s3_bucket_secret_access_key" {
  description = "The secret access key for the IAM user for the S3 bucket"
  value       = aws_iam_access_key.bucket_user.secret
  sensitive   = true
}