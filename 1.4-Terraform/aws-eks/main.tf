module "vpc" {
  source                              = "./vpc"
  cluster_name                        = var.cluster_name
  environment                         = var.environment
  vpc_name                            = var.vpc_name
  vpc_cidr                            = var.vpc_cidr
  availability_zones_count            = var.availability_zones_count
  cidr_block-nat_gateway              = var.cidr_block-nat_gateway
  cidr_block-internet_gateway         = var.cidr_block-internet_gateway
}

module "eks" {
  source                              = "./eks"
  cluster_name                        = var.cluster_name
  environment                         = var.environment
  private_subnets                     = module.vpc.aws_subnets_private
  public_subnets                      = module.vpc.aws_subnets_public
  eks_node_group_instance_types       = var.eks_node_group_instance_types
  fargate_namespace                   = var.fargate_namespace
}

module "kubernetes" {
  source                              = "./kubernetes"
  cluster_name                        = module.eks.cluster_name
  cluster_id                          = module.eks.cluster_id
  vpc_id                              = module.vpc.vpc_id
}

/*
module "database" {
  source                              = "./database"
  secret_id                           = var.secret_id
  identifier                          = var.identifier
  allocated_storage                   = var.allocated_storage
  storage_type                        = var.storage_type
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  database_name                       = var.database_name
  environment                         = var.environment
  vpc_id                              = module.vpc.vpc_id
  private_subnets                     = module.vpc.aws_subnets_private
}
*/
