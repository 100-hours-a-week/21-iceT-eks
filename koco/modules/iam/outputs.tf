output "eks_node_group_role_arn" {
    description = "EKS node group IAM 역할 ARN"
    value = aws_iam_role.node_group_role.arn
}
output "ebs_csi_irsa_role_arn" {
  value = aws_iam_role.ebs_csi_irsa_role.arn
}