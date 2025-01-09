resource "aws_ses_domain_identity" "main" {
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

# Email template for scholarship application notifications
resource "aws_ses_template" "application_notification" {
  name    = "${var.app_name}-application-notification-${var.environment}"
  subject = "Application Submitted for {{scholarship_title}}"
  html    = <<EOF
	<h1>Application Submitted</h1>
	<p>Dear {{applicant_name}},</p>
	<p>Your application for the scholarship "{{scholarship_title}}" has been submitted successfully.</p>
	<p>Thank you for applying!</p>
	<p>Best regards,</p>
	<p>The Scholarship Committee</p>
	EOF
  text    = <<EOF
	Application Submitted
	Dear {{applicant_name}},
	Your application for the scholarship "{{scholarship_title}}" has been submitted successfully.
	Thank you for applying!
	Best regards,
	The Scholarship Committee
	EOF
}

resource "aws_iam_policy" "ses_policy" {
  name = "${var.app_name}-ses-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ses:SendTemplatedEmail"
        ]
        Resource = [
          aws_ses_domain_identity.main.arn,
          "${aws_ses_domain_identity.main.arn}/*"
        ]
      }
    ]
  })
}
