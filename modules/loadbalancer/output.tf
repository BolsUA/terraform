output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "internal_alb_security_group_id" {
  description = "Internal ALB security group ID"
  value       = aws_security_group.internal_alb.id
}

output "alb_internal_listener_http_arn" {
  description = "The ARN of the internal HTTP listener"
  value       = aws_lb_listener.internal_listener_http.arn
}

output "frontend_target_group_arn" {
  description = "Frontend target group ARN"
  value       = aws_lb_target_group.frontend_tg.arn
}

output "scholarships_backend_target_group_arn" {
  description = "Backend target group ARN"
  value       = aws_lb_target_group.scholarships_backend_tg.arn
}

output "applications_backend_target_group_arn" {
  description = "Backend target group ARN"
  value       = aws_lb_target_group.applications_backend_tg.arn
}

output "grading_selection_backend_target_group_arn" {
  description = "Backend target group ARN"
  value       = aws_lb_target_group.grading_selection_backend_tg.arn
}