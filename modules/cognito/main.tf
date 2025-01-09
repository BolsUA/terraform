resource "aws_cognito_user_pool" "main" {
  name = "${var.app_name}-user-pool-${var.environment}"

  # Add password policy
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # Add username attributes and auto verify email
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Add schema attributes
  schema {
    name                = "name"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 7
      max_length = 256
    }
  }

  # Account recovery
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  tags = {
    Name        = "${var.app_name}-user-pool"
    Environment = var.environment
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.app_name}-client-${var.environment}"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret = true

  # OAuth configuration
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.app_name}-${var.environment}"
  user_pool_id = aws_cognito_user_pool.main.id
}

# Create the user groups
resource "aws_cognito_user_group" "secretary" {
  name         = "secretary"
  description  = "Secretaries who manage the proposals of scholarships"
  user_pool_id = aws_cognito_user_pool.main.id
  precedence   = 1
}

resource "aws_cognito_user_group" "jury" {
  name         = "jury"
  description  = "Jury members who evaluate the applicants of scholarships"
  user_pool_id = aws_cognito_user_pool.main.id
  precedence   = 2
}

resource "aws_cognito_user_group" "proposers" {
  name         = "proposers"
  description  = "Users who can submit proposals of scholarships"
  user_pool_id = aws_cognito_user_pool.main.id
  precedence   = 3
}

resource "aws_iam_policy" "cognito_policy" {
  name = "${var.app_name}-cognito-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:ListUsers",
          "cognito-idp:AdminGetUser",
          "cognito-idp:AdminListGroupsForUser",
          "cognito-idp:ListUsersInGroup",
          "cognito-idp:AdminListUserAuthEvents",
          "cognito-idp:GetGroup",
          "cognito-idp:ListGroups",
          "cognito-idp:DescribeUserPoolClient",
          "cognito-idp:GetUserPoolMfaConfig",
          "cognito-idp:AdminUserGlobalSignOut",
          "cognito-idp:AdminUpdateUserAttributes",
          "cognito-idp:DescribeUserPool"
        ]
        Resource = [
          aws_cognito_user_pool.main.arn,
          "${aws_cognito_user_pool.main.arn}/client/${aws_cognito_user_pool_client.client.id}",
        ]
      }
    ]
  })
}
