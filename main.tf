module "subnet" {
  source = "./modules/subnet"

  count        = length(local.cidr_range_available) > 0 ? 1 : 0
  vpc_id       = data.aws_vpc.dextrus.id
  subnet_cidr  = local.cidr_range_available
  az           = local.az
  cluster_name = var.cluster_name
}

# resource "aws_subnet" "example" {
#   vpc_id = var.vpc_id

#   cidr_block = {
#     qa    = "10.0.1.0/24"
#     test  = "10.0.2.0/24"
#     prod  = "10.0.3.0/24"
#     other = "10.0.4.0/24"
#   }[terraform.workspace]
# }

module "eks" {
  source = "./modules/eks"

  cluster_name     = var.cluster_name
  cluster_role_arn = var.cluster_role_arn
  log_type         = var.log_type
  #subnets             = var.subnet_create ? slice(module.subnet[0].ids, 0, 2) : local.subnet_ids 
  subnets             = local.subnet_ids
  security_groups     = flatten([data.aws_security_groups.private_sg.ids, data.aws_security_groups.public_sg.ids, data.aws_security_groups.dextrus_sg.ids])
  retention_in_days   = var.retention_in_days
  node_group_name     = var.node_group_name
  node_group_role_arn = var.node_group_role_arn
  disk_size           = var.disk_size
  key_name            = var.key_name
  desired_size        = var.desired_size
  max_size            = var.max_size
  min_size            = var.min_size
  eks_ami_type        = var.eks_ami_type
  eks_instance_type   = var.eks_instance_type
  node_key            = var.node_key
  node_value          = var.node_value
}

module "karpenter_template" {
  source = "./modules/karpenter"
 
  cluster_name     = var.cluster_name
  cluster_endpoint = module.eks.endpoint
  account          = var.account
  node_key         = var.node_key
  node_value       = var.node_value
  production       = var.production
  instance_size    = var.instance_size
  subnet_id        = join(",",local.subnet_ids) 
      #"subnet-0f65ddd7c4fba4335" 
			#join(",",local.subnet_ids)
  security_group   = join(",",flatten([module.eks.instances[0].cluster_security_group_id,module.eks.eks_node_group]))
			#join(",",flatten([data.aws_security_groups.private_sg.ids, data.aws_security_groups.public_sg.ids, data.aws_security_groups.dextrus_sg.ids]))


  depends_on = [
    module.eks
  ]
}

module "monitoring_template"  {
  source = "./modules/monitoring"

  host_name       = var.host_name
  
  depends_on = [
    module.eks
  ]
}

module "kube_dashboard_template" {
  source = "./modules/kubedashboard"

  host_name       = var.host_name

  depends_on = [
    module.eks
  ]
}
