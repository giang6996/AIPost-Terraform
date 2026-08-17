module "networking" {
  source = "../../modules/networking"

  name_prefix = local.name_prefix

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs

  private_app_subnet_cidrs = var.private_app_subnet_cidrs

  private_db_subnet_cidrs = var.private_db_subnet_cidrs

  nat_mode = var.nat_mode

  common_tags = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  name_prefix = local.name_prefix

  cluster_version = var.eks_cluster_version

  private_app_subnet_ids = module.networking.private_app_subnet_ids

  node_instance_types = var.eks_node_instance_types

  node_min_size = var.eks_node_min_size

  node_desired_size = var.eks_node_desired_size

  node_max_size = var.eks_node_max_size

  common_tags = local.common_tags
}