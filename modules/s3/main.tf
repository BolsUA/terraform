resource "aws_s3_bucket" "main" {
  bucket = "${var.app_name}-storage-${var.environment}"

  tags = {
    Name        = "${var.app_name}-storage"
    Environment = var.environment
  }
}

resource "aws_iam_policy" "bucket_policy" {
  name = "${var.app_name}-bucket-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.main.arn,
          "${aws_s3_bucket.main.arn}/*"
        ]
      }
    ]
  })
}
