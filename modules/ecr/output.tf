output "frontend_repository_url" {
  description = "URL of the frontend ECR repository"
  value       = aws_ecr_repository.frontend.repository_url
}

output "scholarships_backend_repository_url" {
  description = "URL of the scholarships backend ECR repository"
  value       = aws_ecr_repository.scholarships_backend.repository_url
}

output "applications_backend_repository_url" {
  description = "URL of the applications backend ECR repository"
  value       = aws_ecr_repository.applications_backend.repository_url
}

output "grading_selection_backend_repository_url" {
  description = "URL of the grading and selection backend ECR repository"
  value       = aws_ecr_repository.grading_selection_backend.repository_url
}