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
  source      = "./modules/networking"
  app_name    = var.app_name
  environment = var.environment
}

module "cognito" {
  source      = "./modules/cognito"
  app_name    = var.app_name
  environment = var.environment
  region      = var.region
}