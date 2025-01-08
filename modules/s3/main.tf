resource "aws_s3_bucket" "main" {
  bucket = "${var.app_name}-storage-${var.environment}"

  tags = {
    Name        = "${var.app_name}-storage"
    Environment = var.environment
  }
}

resource "aws_iam_user" "bucket_user" {
  name = "${var.app_name}-bucket-user-${var.environment}"
}

resource "aws_iam_access_key" "bucket_user" {
  user = aws_iam_user.bucket_user.name
}

resource "aws_iam_user_policy" "bucket_policy" {
  name = "${var.app_name}-bucket-policy-${var.environment}"
  user = aws_iam_user.bucket_user.name

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
