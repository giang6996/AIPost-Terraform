output "backend_role_arn" {
  value = aws_iam_role.backend.arn
}

output "backend_role_name" {
  value = aws_iam_role.backend.name
}

output "pod_identity_association_id" {
  value = aws_eks_pod_identity_association.backend.association_id
}