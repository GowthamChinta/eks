resource "aws_cloudwatch_log_group" "cluster_cloudwatch" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.retention_in_days
}

resource "aws_eks_cluster" "cluster" {
  name                      = var.cluster_name
  role_arn                  = var.cluster_role_arn
  enabled_cluster_log_types = var.log_type

  vpc_config {
    subnet_ids              = var.subnets
    security_group_ids      = var.security_groups
    endpoint_public_access  = false
    endpoint_private_access = true
  }

  depends_on = [aws_cloudwatch_log_group.cluster_cloudwatch]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.subnets
  disk_size       = var.disk_size

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = var.security_groups
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type       = var.eks_ami_type
  instance_types = var.eks_instance_type

  tags = {
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  }
  taint {
    key    = var.node_key
    value  = var.node_value
    effect = "NO_SCHEDULE"
  }
  labels = {
    "${var.node_key}" = "${var.node_value}"
  }
}

resource "aws_security_group_rule" "cluster_ingress_rule" {
  count = length(var.security_groups)

  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = lookup(aws_eks_cluster.cluster.vpc_config[0], "cluster_security_group_id")
  security_group_id        = var.security_groups[count.index]
}
