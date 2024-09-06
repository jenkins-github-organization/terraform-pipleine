terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "ecr" {
  source           = "./modules"
  region           = var.region
  repository_names = var.repository_names
  image_mutability = var.image_mutability
  owner            = var.owner
  environment      = var.environment
  cost_center      = var.cost_center
  application      = var.application
  tags             = var.tags
}
