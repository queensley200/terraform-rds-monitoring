terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"  
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock"         
    encrypt        = true
  }
} 

module "networking" {
  source = "./modules/networking"

  environment     = var.environment
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "security" {
  source = "./modules/security"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
}

module "compute" {
  source = "./modules/compute"

  environment     = var.environment
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnet_ids
  private_subnets = module.networking.private_subnet_ids
  alb_sg_id      = module.security.alb_security_group_id
  ec2_sg_id      = module.security.ec2_security_group_id
  app_instance_type = var.app_instance_type
  app_min_size     = var.app_min_size
  app_max_size     = var.app_max_size
  app_desired_capacity = var.app_desired_capacity
  key_name         = var.key_name
}

module "database" {
  source = "./modules/database"

  environment     = var.environment
  vpc_id         = module.networking.vpc_id
  private_subnets = module.networking.private_subnet_ids
  db_sg_id       = module.security.db_security_group_id
  db_username    = var.db_username
  db_password    = var.db_password
  db_name        = var.db_name
  db_instance_class = var.db_instance_class
}

module "monitoring" {
  source = "./modules/monitoring"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
} 