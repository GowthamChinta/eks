variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC."
}

variable "dns_support" {
  type        = string
  description = "A boolean flag to enable/disable DNS support in the VPC."
}

variable "dns_hostnames" {
  type        = string
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
}

variable "subnet_cidr" {
  type        = list(any)
  description = "Subnet Map"
}

variable "az" {
  type = list(any)
}

variable "key_name" {
  type = string
}

variable "public_key" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "device_name" {
  type = string
}

variable "volume_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "log_type" {
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

variable "bucket_name" {
  type = string
}

variable "acl" {
  type = string
}

variable "versioned" {
  type = bool
}

variable "region" {
  type = string
}

variable "force_destroy" {
  type = bool
}

variable "node_key" {
  type        = string
  description = "A key to assign node affinity and toleration."
}

variable "node_value" {
  type        = string
  description = "A value to assign node affinity and toleration."
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

variable "host_name" {
  type        = string
  description = "A value to assign node affinity and toleration."
}

# variable "subnet_id" {
#     type = string
#     description = "subnet_id details"
# }

# variable "subnet_group" {
#   type = string
# }