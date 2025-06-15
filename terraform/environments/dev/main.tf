module "networking" {
  source = "../../modules/networking"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "compute" {
  source = "../../modules/compute"

  environment        = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  instance_type     = var.instance_type
  min_size          = var.min_size
  max_size          = var.max_size
  desired_capacity  = var.desired_capacity
}

module "database" {
  source = "../../modules/database"

  environment        = var.environment
  vpc_id            = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  db_instance_class = var.db_instance_class
  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

module "storage" {
  source = "../../modules/storage"

  environment = var.environment
} 