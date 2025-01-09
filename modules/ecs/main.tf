# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-ecs-cluster-${var.environment}"

  # setting {
  #   name  = "containerInsights"
  #   value = "enabled"
  # }

  tags = {
    Name        = "${var.app_name}-cluster"
    Environment = var.environment
  }
}

# ECS Task Execution Role
data "aws_iam_policy_document" "ecs_task_execution_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.app_name}-ecs-task-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_policy.json
}

# Attach the Amazon ECS managed policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the Cognito policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_cognito" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.cognito_policy_arn
}

# Attach the CloudWatch Logs policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_cloudwatch" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.cloudwatch_policy_arn
}

# Attach the S3 bucket policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_s3" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.s3_bucket_policy_arn
}

# Attach the SQS policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_sqs" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.sqs_policy_arn
}

# Attach the SES policy to the task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_ses" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.ses_policy_arn
}

# Security Group
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-ecs-tasks-sg-${var.environment}"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.frontend_port
    to_port         = var.frontend_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    from_port       = var.scholarships_backend_port
    to_port         = var.scholarships_backend_port
    protocol        = "tcp"
    security_groups = [var.internal_alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-ecs-tasks-sg"
    Environment = var.environment
  }
}

# ECS Task Definitions
resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.app_name}-frontend-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${var.frontend_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.frontend_port
          hostPort      = var.frontend_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "AUTH_SECRET",
          value = var.auth_secret
        },
        {
          name  = "AUTH_COGNITO_ID",
          value = var.auth_cognito_client_id
        },
        {
          name  = "AUTH_COGNITO_SECRET",
          value = var.auth_cognito_secret
        },
        {
          name  = "AUTH_COGNITO_ISSUER",
          value = var.auth_cognito_issuer
        },
        {
          name  = "AUTH_TRUST_HOST",
          value = "true"
        },
        {
          name  = "NEXTAUTH_URL",
          value = "https://bolsua.pt"
        },
        {
          name  = "PORT",
          value = "80"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-frontend-${var.environment}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# Scholarships Backend ECS Task Definition
resource "aws_ecs_task_definition" "scholarships_backend" {
  family                   = "${var.app_name}-scholarships-backend-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "scholarships-backend"
      image     = "${var.scholarships_backend_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.scholarships_backend_port
          hostPort      = var.scholarships_backend_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DATABASE_URL"
          value = var.scholarships_db_connection_string
        },
        {
          name  = "REGION"
          value = var.region
        },
        {
          name  = "USER_POOL_ID",
          value = var.auth_cognito_user_pool_id
        },
        {
          name  = "FRONTEND_URL",
          value = "https://bolsua.pt"
        },
        {
          name  = "QUEUE_URL",
          value = var.scholarships_applications_queue_url
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-scholarships-backend-${var.environment}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# Application Backend ECS Task Definition
resource "aws_ecs_task_definition" "applications_backend" {
  family                   = "${var.app_name}-applications-backend-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "applications-backend"
      image     = "${var.applications_backend_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.applications_backend_port
          hostPort      = var.applications_backend_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DATABASE_URL"
          value = var.applications_db_connection_string
        },
        {
          name  = "REGION"
          value = var.region
        },
        {
          name  = "USER_POOL_ID",
          value = var.auth_cognito_user_pool_id
        },
        {
          name  = "FRONTEND_URL",
          value = "https://bolsua.pt"
        },
        {
          name  = "DEADLINE_QUEUE_URL",
          value = var.scholarships_applications_queue_url
        },
        {
          name  = "TO_GRADING_QUEUE_URL",
          value = var.applications_grading_queue_url
        },
        {
          name  = "APP_GRADING_QUEUE_URL",
          value = var.grading_applications_queue_url
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-applications-backend-${var.environment}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# Grading and Selection Backend ECS Task Definition
resource "aws_ecs_task_definition" "grading_selection_backend" {
  family                   = "${var.app_name}-grading-selection-backend-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "grading-selection-backend"
      image     = "${var.grading_selection_backend_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.grading_selection_backend_port
          hostPort      = var.grading_selection_backend_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DATABASE_URL"
          value = var.grading_selection_db_connection_string
        },
        {
          name  = "REGION"
          value = var.region
        },
        {
          name  = "USER_POOL_ID",
          value = var.auth_cognito_user_pool_id
        },
        {
          name  = "FRONTEND_URL",
          value = "https://bolsua.pt"
        },
        {
          name  = "TO_GRADING_QUEUE_URL",
          value = var.applications_grading_queue_url
        },
        {
          name  = "APP_GRADING_QUEUE_URL",
          value = var.grading_applications_queue_url
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-grading-selection-backend-${var.environment}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# Frontend ECS Service
resource "aws_ecs_service" "frontend" {
  name            = "${var.app_name}-frontend-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.frontend_target_group_arn
    container_name   = "frontend"
    container_port   = var.frontend_port
  }
}

# Scholarships Backend ECS Service
resource "aws_ecs_service" "scholarships_backend" {
  name            = "${var.app_name}-scholarships-backend-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.scholarships_backend.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.scholarships_backend_target_group_arn
    container_name   = "scholarships-backend"
    container_port   = var.scholarships_backend_port
  }
}

# Application Backend ECS Service
resource "aws_ecs_service" "applications_backend" {
  name            = "${var.app_name}-applications-backend-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.applications_backend.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.applications_backend_target_group_arn
    container_name   = "applications-backend"
    container_port   = var.applications_backend_port
  }
}

# Grading and Selection Backend ECS Service
resource "aws_ecs_service" "grading_selection_backend" {
  name            = "${var.app_name}-grading-selection-backend-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.grading_selection_backend.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.grading_selection_backend_target_group_arn
    container_name   = "grading-selection-backend"
    container_port   = var.grading_selection_backend_port
  }
}
