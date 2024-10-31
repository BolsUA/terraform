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

module "database" {
  source = "./modules/database"

  app_name    = var.app_name
  environment = var.environment

  vpc_id              = module.networking.vpc_id
  private_subnet_ids  = module.networking.private_subnet_ids
  allowed_cidr_blocks = [module.networking.vpc_cidr_block]

  people_db_name     = var.people_db_name
  people_db_username = var.people_db_username
  people_db_password = var.people_db_password

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
