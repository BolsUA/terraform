# Scholarships to Applications Queue
resource "aws_sqs_queue" "scholarships_applications" {
  name = "${var.app_name}-scholarships-applications-queue-${var.environment}"

  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout

  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.scholarships_applications_dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = {
    Name        = "${var.app_name}-scholarships-applications-queue"
    Environment = var.environment
  }
}

# Scholarships to Applications DLQ (Dead Letter Queue)
resource "aws_sqs_queue" "scholarships_applications_dlq" {
  count = var.enable_dlq ? 1 : 0

  name                      = "${var.app_name}-scholarships-applications-dlq-${var.environment}"
  message_retention_seconds = var.dlq_retention_seconds

  tags = {
    Name        = "${var.app_name}-scholarships-applications-dlq"
    Environment = var.environment
  }
}

# Applications to Grading and Selection Queue
resource "aws_sqs_queue" "applications_grading" {
  name = "${var.app_name}-applications-grading-queue-${var.environment}"

  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout

  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.applications_grading_dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = {
    Name        = "${var.app_name}-applications-grading-queue"
    Environment = var.environment
  }
}

# Applications to Grading and Selection DLQ (Dead Letter Queue)
resource "aws_sqs_queue" "applications_grading_dlq" {
  count = var.enable_dlq ? 1 : 0

  name                      = "${var.app_name}-applications-grading-dlq-${var.environment}"
  message_retention_seconds = var.dlq_retention_seconds

  tags = {
    Name        = "${var.app_name}-applications-grading-dlq"
    Environment = var.environment
  }
}

# Grading and Selection to Applications Queue
resource "aws_sqs_queue" "grading_applications" {
  name = "${var.app_name}-grading-applications-queue-${var.environment}"

  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout

  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.grading_applications_dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = {
    Name        = "${var.app_name}-grading-applications-queue"
    Environment = var.environment
  }
}

# Grading and Selection to Applications DLQ (Dead Letter Queue)
resource "aws_sqs_queue" "grading_applications_dlq" {
  count = var.enable_dlq ? 1 : 0

  name                      = "${var.app_name}-grading-applications-dlq-${var.environment}"
  message_retention_seconds = var.dlq_retention_seconds

  tags = {
    Name        = "${var.app_name}-grading-applications-dlq"
    Environment = var.environment
  }
}

# Notifications Queue
resource "aws_sqs_queue" "notifications" {
  name = "${var.app_name}-notifications-queue-${var.environment}"

  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout

  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.notifications_dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = {
    Name        = "${var.app_name}-notifications-queue"
    Environment = var.environment
  }
}

# Notifications DLQ (Dead Letter Queue)
resource "aws_sqs_queue" "notifications_dlq" {
  count = var.enable_dlq ? 1 : 0

  name                      = "${var.app_name}-notifications-dlq-${var.environment}"
  message_retention_seconds = var.dlq_retention_seconds

  tags = {
    Name        = "${var.app_name}-notifications-dlq"
    Environment = var.environment
  }
}

resource "aws_iam_policy" "queue_policy" {
  name = "${var.app_name}-queue-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          aws_sqs_queue.scholarships_applications.arn,
          aws_sqs_queue.applications_grading.arn,
          aws_sqs_queue.grading_applications.arn,
          aws_sqs_queue.notifications.arn,
          var.enable_dlq ? aws_sqs_queue.scholarships_applications_dlq[0].arn : "",
          var.enable_dlq ? aws_sqs_queue.applications_grading_dlq[0].arn : "",
          var.enable_dlq ? aws_sqs_queue.grading_applications_dlq[0].arn : "",
          var.enable_dlq ? aws_sqs_queue.notifications_dlq[0].arn : ""
        ]
      }
    ]
  })
}
