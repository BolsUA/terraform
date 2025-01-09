# ECR Repository for frontend
resource "aws_ecr_repository" "frontend" {
  name                 = "${var.app_name}-frontend-${var.environment}"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name        = "${var.app_name}-frontend"
    Environment = var.environment
  }
}

# ECR Repository for scholarships service
resource "aws_ecr_repository" "scholarships_backend" {
  name                 = "${var.app_name}-scholarships-backend-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_name}-scholarships"
    Environment = var.environment
  }
}

# ECR Repository for applications service
resource "aws_ecr_repository" "applications_backend" {
  name                 = "${var.app_name}-applications-backend-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_name}-applications"
    Environment = var.environment
  }
}

# ECR Repository for grading and selection service
resource "aws_ecr_repository" "grading_selection_backend" {
  name                 = "${var.app_name}-grading-selection-backend-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_name}-grading-selection"
    Environment = var.environment
  }
}