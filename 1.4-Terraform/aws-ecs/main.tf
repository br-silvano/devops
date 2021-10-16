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

module "ecs" {
  source                              = "./ecs"
  cluster_name                        = var.cluster_name
  environment                         = var.environment
  vpc                                 = module.vpc.vpc_id
  private_subnets                     = module.vpc.aws_subnets_private
  public_subnets                      = module.vpc.aws_subnets_public
  app_count                           = var.app_count
}
