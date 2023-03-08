variable "node_key" {
  type        = string
  description = "A key to assign node affinity and toleration."
}

variable "node_value" {
  type        = string
  description = "A value to assign node affinity and toleration."
}

variable "cluster_name" {
  type        = string
  description = "Cluster name information to fetch from eks module"
}

variable "cluster_endpoint" {
  type        = string
  description = "Cluster Endpoint information to fetch from eks module"
}

variable "account" {
  type        = string
  description = "account number information "
}

variable "production" {
  type        = bool
  description = "weather environment is production"
}

variable "instance_size" {
  type        = string
  description = "Size of the Instance"
}

variable "subnet_id" {
  type        = string
  description = "subnet_id details"
}

variable "security_group" {
  type = string
}
