output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}


output "instances" {
  value = aws_eks_cluster.cluster.vpc_config
}

output "eks_node_group" {
  value = aws_eks_node_group.eks_node_group.resources[0].remote_access_security_group_id
}