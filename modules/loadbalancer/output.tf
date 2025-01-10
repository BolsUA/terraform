output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "internal_alb_security_group_id" {
  description = "Internal ALB security group ID"
  value       = aws_security_group.internal_alb.id
}

output "alb_internal_listener_scholarships_arn" {
  description = "The ARN of the internal HTTP listener for the scholarships service"
  value       = aws_lb_listener.internal_listener_scholarships.arn
}

output "alb_internal_listener_applications_arn" {
  description = "The ARN of the internal HTTP listener for the applications service"
  value       = aws_lb_listener.internal_listener_applications.arn
}

output "alb_internal_listener_grading_selection_arn" {
  description = "The ARN of the internal HTTP listener for the grading selection service"
  value       = aws_lb_listener.internal_listener_grading_selection.arn
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