output "ses_policy_arn" {
  description = "The ARN of the SES IAM policy"
  value       = aws_iam_policy.ses_policy.arn
}

output "domain_identity_arn" {
  description = "The ARN of the SES domain identity"
  value       = aws_ses_domain_identity.main.arn
}

output "dkim_tokens" {
  description = "DKIM tokens for domain verification"
  value       = aws_ses_domain_dkim.main.dkim_tokens
}