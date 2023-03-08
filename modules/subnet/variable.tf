variable "vpc_id" {
  type        = string
  description = "VPC Id."
}

variable "subnet_cidr" {
  type = list
}

variable "az" {
  type = list
}

variable "cluster_name" {
  type = string
}
