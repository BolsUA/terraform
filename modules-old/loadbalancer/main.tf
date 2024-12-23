# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.app_name}-alb-sg-${var.environment}"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-alb-sg"
    Environment = var.environment
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.app_name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.environment
  }
}

# ALB Target Groups

# Frontend Target Group
resource "aws_lb_target_group" "frontend_tg" {
  name        = "${var.app_name}-frontend-tg-${var.environment}"
  port        = var.frontend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

# People Service Target Group
# resource "aws_lb_target_group" "people_backend_tg" {
#   name        = "${var.app_name}-people-tg-${var.environment}"
#   port        = var.people_backend_port
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     path = "/api/health"
#   }
# }

# # Scholarships Service Target Group
resource "aws_lb_target_group" "scholarships_backend_tg" {
  name        = "${var.app_name}-scholarships-tg-${var.environment}"
  port        = var.scholarships_backend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/api/health"
  }
}

# # Applications Service Target Group
# resource "aws_lb_target_group" "applications_backend_tg" {
#   name        = "${var.app_name}-applications-tg-${var.environment}"
#   port        = var.applications_backend_port
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     path = "/api/health"
#   }
# }

# # Grading and Selection Service Target Group
# resource "aws_lb_target_group" "grading_selection_backend_tg" {
#   name        = "${var.app_name}-grading-selection-tg-${var.environment}"
#   port        = var.grading_selection_backend_port
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     path = "/api/health"
#   }
# }

# ALB Listeners

# Default Listener
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  # default_action {
  #   type = "fixed-response"
  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "Not Found."
  #     status_code  = "404"
  #   }
  # }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:225989371894:certificate/c798aadc-92d7-45c6-b93c-140d0e6c77ea"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# resource "aws_lb_listener_rule" "frontend_rule_http" {
#   listener_arn = aws_lb_listener.listener_http.arn
#   priority     = 300

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

# People Service Listener
# resource "aws_lb_listener" "listener_scholarships_backend" {
#   # count             = 1
#   load_balancer_arn = aws_lb.main.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.scholarships_backend_tg.arn
#   }
# }


# Frontend Listener Rule
# resource "aws_lb_listener_rule" "frontend_rule" {
#   count        = 1
#   listener_arn = aws_lb_listener.listeners[count.index].arn
#   priority     = 500

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

# People Service Listener Rule
# resource "aws_lb_listener_rule" "people_backend_rule" {
#   count        = 2
#   listener_arn = aws_lb_listener.listeners[count.index].arn
#   priority     = 400

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.people_backend_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/people/*"]
#     }
#   }
# }

# Scholarships Service Listener Rule
# resource "aws_lb_listener_rule" "scholarships_backend_rule" {
#   count        = 1
#   listener_arn = aws_lb_listener.listeners[count.index].arn
#   priority     = 300

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.scholarships_backend_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

# Applications Service Listener Rule
# resource "aws_lb_listener_rule" "applications_backend_rule" {
#   count        = 2
#   listener_arn = aws_lb_listener.listeners[count.index].arn
#   priority     = 200

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.applications_backend_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/applications/*"]
#     }
#   }
# }

# Grading and Selection Service Listener Rule
# resource "aws_lb_listener_rule" "grading_selection_backend_rule" {
#   count        = 2
#   listener_arn = aws_lb_listener.listeners[count.index].arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.grading_selection_backend_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/grading-selection/*"]
#     }
#   }
# }
