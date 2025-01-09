output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_client_id" {
  description = "The ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.client.id
}

output "cognito_client_secret" {
  description = "The secret of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.client.client_secret
  sensitive   = true
}

output "cognito_domain" {
  description = "The domain name of the Cognito User Pool"
  value       = "${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region}.amazoncognito.com"
}

output "cognito_user_pool_issuer" {
  description = "The issuer of the Cognito User Pool"
  value       = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}"
}

output "cognito_policy_arn" {
  description = "The ARN of the IAM policy for Cognito"
  value       = aws_iam_policy.cognito_policy.arn
}