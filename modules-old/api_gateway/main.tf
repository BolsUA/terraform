# API Gateway
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.app_name}-api-gw-${var.environment}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["Content-Type", "Authorization"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins = var.allowed_origins
    max_age       = 300
  }

  tags = {
    Name        = "${var.app_name}-api-gw"
    Environment = var.environment
  }
}

# VPC Link for ALB connection
resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.app_name}-vpc-link-${var.environment}"
  security_group_ids = [var.alb_security_group_id]
  subnet_ids         = var.private_subnet_ids

  tags = {
    Name        = "${var.app_name}-vpc-link"
    Environment = var.environment
  }
}

# Stage
resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.environment
  auto_deploy = true

  access_log_settings {
    destination_arn = var.cloudwatch_api_gateway_log_group_arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip            = "$context.identity.sourceIp"
      requestTime   = "$context.requestTime"
      httpMethod    = "$context.httpMethod"
      routeKey      = "$context.routeKey"
      status        = "$context.status"
      protocol      = "$context.protocol"
      responseTime  = "$context.responseLatency"
      integrationError = "$context.integrationErrorMessage"
      authorizationError = "$context.authorizer.error"
      authorizerClaims = "$context.authorizer.claims"
    })
  }

  tags = {
    Name        = "${var.app_name}-api-gw-stage"
    Environment = var.environment
  }
}

# Authorizer
resource "aws_apigatewayv2_authorizer" "main" {
  api_id           = aws_apigatewayv2_api.main.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"

  jwt_configuration {
    audience = [var.cognito_client_id]
    issuer   = var.cognito_user_pool_issuer
  }
}

# Integration with ALB
resource "aws_apigatewayv2_integration" "scholarships" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = var.alb_https_listener_arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id

#   request_parameters = {
#     "overwrite:header.Authorization" = "$request.header.Authorization"
#   }
}

# Routes configuration
resource "aws_apigatewayv2_route" "scholarships" {
  api_id             = aws_apigatewayv2_api.main.id
  route_key          = "ANY /api/scholarships/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.scholarships.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.main.id
}

# Health check route
resource "aws_apigatewayv2_route" "scholarships_health" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /api/scholarships/health"
  target    = "integrations/${aws_apigatewayv2_integration.scholarships.id}"
  depends_on = [ aws_apigatewayv2_integration.scholarships ]
}