output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "alb_https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.listener_https.arn
}

output "frontend_target_group_arn" {
  description = "Frontend target group ARN"
  value       = aws_lb_target_group.frontend_tg.arn
}

output "scholarships_backend_target_group_arn" {
  description = "Scholarships backend target group ARN"
  value       = aws_lb_target_group.scholarships_backend_tg.arn
}