variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "log_type" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "retention_in_days" {
  type = number
}

variable "node_group_name" {
  type = string
}

variable "node_group_role_arn" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "key_name" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "eks_ami_type" {
  type = string
}

variable "eks_instance_type" {
  type = list(string)
}

variable "node_key" {
  type        = string
  description = "A key to assign node affinity and toleration."
}

variable "node_value" {
  type        = string
  description = "A value to assign node affinity and toleration."
}
