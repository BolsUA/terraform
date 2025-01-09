output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "scholarships_db_endpoint" {
  description = "The endpoint of the Scholarships database"
  value       = aws_db_instance.scholarships_db.endpoint
}

output "scholarships_db_connection_string" {
  description = "The connection string for the Scholarships database"
  value       = "postgresql://${var.scholarships_db_username}:${var.scholarships_db_password}@${aws_db_instance.scholarships_db.endpoint}/${var.scholarships_db_name}"
}

output "applications_db_endpoint" {
  description = "The endpoint of the Applications database"
  value       = aws_db_instance.applications_db.endpoint
}

output "applications_db_connection_string" {
  description = "The connection string for the Applications database"
  value       = "postgresql://${var.applications_db_username}:${var.applications_db_password}@${aws_db_instance.applications_db.endpoint}/${var.applications_db_name}"
}

output "grading_selection_db_endpoint" {
  description = "The endpoint of the Grading and Selection database"
  value       = aws_db_instance.grading_selection_db.endpoint
}

output "grading_selection_db_connection_string" {
  description = "The connection string for the Grading and Selection database"
  value       = "postgresql://${var.grading_selection_db_username}:${var.grading_selection_db_password}@${aws_db_instance.grading_selection_db.endpoint}/${var.grading_selection_db_name}"
}