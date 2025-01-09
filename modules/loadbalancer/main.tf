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

# Internal ALB Security Group
resource "aws_security_group" "internal_alb" {
  name        = "${var.app_name}-internal-alb-sg-${var.environment}"
  description = "Security group for internal ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.scholarships_backend_port
    to_port     = var.scholarships_backend_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress {
    from_port   = var.applications_backend_port
    to_port     = var.applications_backend_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress {
    from_port   = var.grading_selection_backend_port
    to_port     = var.grading_selection_backend_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-internal-alb-sg"
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

# Internal Application Load Balancer
resource "aws_lb" "internal_main" {
  name               = "${var.app_name}-internal-alb-${var.environment}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb.id]
  subnets            = var.private_subnet_ids

  tags = {
    Name        = "${var.app_name}-internal-alb"
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
    path    = "/"
    matcher = "200"
  }
}

# Scholarships Service Target Group
resource "aws_lb_target_group" "scholarships_backend_tg" {
  name        = "${var.app_name}-backend-tg-${var.environment}"
  port        = var.scholarships_backend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/scholarships/health"
  }
}

# Applications Service Target Group
resource "aws_lb_target_group" "applications_backend_tg" {
  name        = "${var.app_name}-applications-tg-${var.environment}"
  port        = var.applications_backend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/applications/health"
  }
}

# Grading and Selection Service Target Group
resource "aws_lb_target_group" "grading_selection_backend_tg" {
  name        = "${var.app_name}-grading-sel-tg-${var.environment}"
  port        = var.grading_selection_backend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/grading/health"
  }
}

# ALB Listeners

# Default Listener
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# Internal HTTP Listener for the API Gateway
resource "aws_lb_listener" "internal_listener_http" {
  load_balancer_arn = aws_lb.internal_main.arn
  port              = var.scholarships_backend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scholarships_backend_tg.arn
  }
}

# Internal HTTP Listener for the Applications Service
resource "aws_lb_listener" "internal_listener_applications" {
  load_balancer_arn = aws_lb.internal_main.arn
  port              = var.applications_backend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.applications_backend_tg.arn
  }
}

# Internal HTTP Listener for the Grading Selection Service
resource "aws_lb_listener" "internal_listener_grading_selection" {
  load_balancer_arn = aws_lb.internal_main.arn
  port              = var.grading_selection_backend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grading_selection_backend_tg.arn
  }
}

# HTTPS Listener
resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}
