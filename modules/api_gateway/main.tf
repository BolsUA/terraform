# API Gateway
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.app_name}-api-gw-${var.environment}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers     = ["Content-Type", "Authorization"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins     = var.allowed_origins
    allow_credentials = true
    max_age           = 300
  }

  tags = {
    Name        = "${var.app_name}-api-gw"
    Environment = var.environment
  }
}

# VPC Link for ALB connection
resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.app_name}-vpc-link-${var.environment}"
  security_group_ids = [var.internal_alb_security_group_id]
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
      requestId          = "$context.requestId"
      ip                 = "$context.identity.sourceIp"
      requestTime        = "$context.requestTime"
      httpMethod         = "$context.httpMethod"
      routeKey           = "$context.routeKey"
      status             = "$context.status"
      protocol           = "$context.protocol"
      responseTime       = "$context.responseLatency"
      integrationError   = "$context.integrationErrorMessage"
      authorizationError = "$context.authorizer.error"
      authorizerClaims   = "$context.authorizer.claims"
    })
  }

  tags = {
    Name        = "${var.app_name}-api-gw-stage"
    Environment = var.environment
  }
}

# Custom domain name for the API Gateway
resource "aws_apigatewayv2_domain_name" "main" {
  domain_name = var.api_domain

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  domain_name = aws_apigatewayv2_domain_name.main.id
  stage       = aws_apigatewayv2_stage.main.id
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
  integration_uri    = var.alb_internal_listener_http_arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id
}

# Routes configuration

# OPTIONS route for CORS
# resource "aws_apigatewayv2_route" "scholarships_options" {
#   api_id    = aws_apigatewayv2_api.main.id
#   route_key = "OPTIONS /scholarships/{proxy+}"
#   target    = "integrations/${aws_apigatewayv2_integration.scholarships.id}"
# }

# Regular route with JWT authorization for all other methods
resource "aws_apigatewayv2_route" "scholarships" {
  api_id             = aws_apigatewayv2_api.main.id
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.scholarships.id}"
  # authorization_type = "JWT"
  # authorizer_id      = aws_apigatewayv2_authorizer.main.id
}

# resource "aws_apigatewayv2_route" "scholarships2" {
#   api_id             = aws_apigatewayv2_api.main.id
#   route_key          = "ANY /scholarships"
#   target             = "integrations/${aws_apigatewayv2_integration.scholarships.id}"
#   # authorization_type = "JWT"
#   # authorizer_id      = aws_apigatewayv2_authorizer.main.id
# }

# resource "aws_apigatewayv2_route" "docs" {
#   api_id             = aws_apigatewayv2_api.main.id
#   route_key          = "ANY /docs"
#   target             = "integrations/${aws_apigatewayv2_integration.scholarships.id}"
#   # authorization_type = "JWT"
#   # authorizer_id      = aws_apigatewayv2_authorizer.main.id
# }

# Health check route
resource "aws_apigatewayv2_route" "scholarships_health" {
  api_id     = aws_apigatewayv2_api.main.id
  route_key  = "GET /health"
  target     = "integrations/${aws_apigatewayv2_integration.scholarships.id}"
}
