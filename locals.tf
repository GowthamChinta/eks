#This will fetch push subnet_id information into local.subnet_ids which can be used in EKS module
locals {
  #subnet_ids = length(var.subnet_ids_for_eks) > 0 ? var.subnet_ids_for_eks : data.aws_subnets.dextrus.ids
  subnet_ids = data.aws_subnets.dextrus.ids
}

#This compares new subnets with existing subnets and subtracts the existing subnet 
#information from new subnet and outputs list of subnets to be created
#based on CIDR block
locals {
  cidr_range_available = flatten([
    setsubtract(var.subnet_cidr, [for subnet in data.aws_subnet.subnet : subnet.cidr_block])
  ])
}


#Faced a bug that both subnets provided are in same az when one subnet is available
# and  one subnet needs to be created. 

#If provided subnet_cidr is already available then check which availability zone it is been created into 
#and utilize the other az provided in var.az
locals {
  cidr_range_existing = flatten([
    setintersection(var.subnet_cidr, [for subnet in data.aws_subnet.subnet : subnet.cidr_block])
  ])
}

#compare the existing az's used and subsctract from the range given in variable
locals {
  az = flatten([
    setsubtract(var.az, [for zone in data.aws_subnet.az_existing : zone.availability_zone])
  ])
}

output "cidr_range_existing" {
  #value = flatten([for az in data.aws_subnet.cidr_range_existing : data.aws_subnet.cidr_range_existing.availability_zone])
  #value = [for subnet in data.aws_subnet.cidr_range_existing: subnet.cidr_block]
  #value = [for subnet in data.aws_subnet.subnet : subnet.cidr_block]
  value = data.aws_subnet.az_existing
}