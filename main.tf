terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "networking" {
  source = "./modules/networking"

  app_name    = var.app_name
  environment = var.environment
}

module "cognito" {
  source = "./modules/cognito"

  app_name    = var.app_name
  environment = var.environment
  region      = var.region
}

module "s3" {
  source = "./modules/s3"

  app_name    = var.app_name
  environment = var.environment
}

module "sqs" {
  source = "./modules/sqs"

  app_name    = var.app_name
  environment = var.environment
}

module "ses" {
  source = "./modules/ses"

  app_name    = var.app_name
  environment = var.environment
}

module "database" {
  source = "./modules/database"

  app_name    = var.app_name
  environment = var.environment

  vpc_id              = module.networking.vpc_id
  private_subnet_ids  = module.networking.private_subnet_ids
  allowed_cidr_blocks = [module.networking.vpc_cidr_block]

  scholarships_db_name     = var.scholarships_db_name
  scholarships_db_username = var.scholarships_db_username
  scholarships_db_password = var.scholarships_db_password

  applications_db_name     = var.applications_db_name
  applications_db_username = var.applications_db_username
  applications_db_password = var.applications_db_password

  grading_selection_db_name     = var.grading_selection_db_name
  grading_selection_db_username = var.grading_selection_db_username
  grading_selection_db_password = var.grading_selection_db_password
}

module "ecr" {
  source = "./modules/ecr"

  app_name    = var.app_name
  environment = var.environment
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  app_name           = var.app_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  certificate_arn = var.certificate_arn

  frontend_port                  = var.frontend_port
  scholarships_backend_port      = var.scholarships_backend_port
  applications_backend_port      = var.applications_backend_port
  grading_selection_backend_port = var.grading_selection_backend_port
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  app_name    = var.app_name
  environment = var.environment
  region      = var.region
}

module "ecs" {
  source = "./modules/ecs"

  app_name    = var.app_name
  environment = var.environment
  region      = var.region

  vpc_id                         = module.networking.vpc_id
  alb_security_group_id          = module.loadbalancer.alb_security_group_id
  internal_alb_security_group_id = module.loadbalancer.internal_alb_security_group_id
  private_subnet_ids             = module.networking.private_subnet_ids

  cloudwatch_logs = module.cloudwatch.cloudwatch_logs_arn
  s3_bucket_policy_arn = module.s3.s3_bucket_policy_arn
  sqs_policy_arn = module.sqs.sqs_policy_arn
  ses_policy_arn = module.ses.ses_policy_arn

  frontend_repository_url   = module.ecr.frontend_repository_url
  frontend_port             = var.frontend_port
  auth_secret               = var.auth_secret
  auth_cognito_client_id    = module.cognito.cognito_client_id
  auth_cognito_user_pool_id = module.cognito.cognito_user_pool_id
  auth_cognito_secret       = module.cognito.cognito_client_secret
  auth_cognito_issuer       = module.cognito.cognito_user_pool_issuer
  frontend_target_group_arn = module.loadbalancer.frontend_target_group_arn

  scholarships_backend_repository_url   = module.ecr.scholarships_backend_repository_url
  scholarships_backend_port             = var.scholarships_backend_port
  scholarships_db_connection_string     = module.database.scholarships_db_connection_string
  scholarships_backend_target_group_arn = module.loadbalancer.scholarships_backend_target_group_arn

  # applications_backend_repository_url   = module.ecr.applications_backend_repository_url
  # applications_backend_port             = var.applications_backend_port
  # applications_db_connection_string     = module.database.applications_db_connection_string
  # applications_backend_target_group_arn = module.loadbalancer.applications_backend_target_group_arn

  # grading_selection_backend_repository_url   = module.ecr.grading_selection_backend_repository_url
  # grading_selection_backend_port             = var.grading_selection_backend_port
  # grading_selection_db_connection_string     = module.database.grading_selection_db_connection_string
  # grading_selection_backend_target_group_arn = module.loadbalancer.grading_selection_backend_target_group_arn
}

module "api_gateway" {
  source = "./modules/api_gateway"

  app_name    = var.app_name
  environment = var.environment
  region      = var.region

  certificate_arn = var.certificate_arn

  cloudwatch_api_gateway_log_group_arn = module.cloudwatch.cloudwatch_api_gateway_log_group_arn
  internal_alb_security_group_id       = module.loadbalancer.internal_alb_security_group_id
  alb_internal_listener_http_arn       = module.loadbalancer.alb_internal_listener_http_arn
  private_subnet_ids                   = module.networking.private_subnet_ids
  cognito_client_id                    = module.cognito.cognito_client_id
  cognito_user_pool_issuer             = module.cognito.cognito_user_pool_issuer
}
