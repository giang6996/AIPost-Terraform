output "vpc_id" {
  description = "VPC used by the EKS environment."
  value       = module.networking.vpc_id
}

output "private_app_subnet_ids" {
  description = "Private subnets hosting EKS worker nodes."
  value       = module.networking.private_app_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  description = "Name of the EKS managed node group."
  value       = module.eks.node_group_name
}

output "eks_cluster_security_group_id" {
  description = "Security group created for the EKS cluster."
  value       = module.eks.cluster_security_group_id
}