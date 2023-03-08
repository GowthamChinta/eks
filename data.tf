#Fetch vpc details from tag information
data "aws_vpc" "dextrus" {
  tags = {
    iac              = "terraform"
    Application-Name = "Dextrus"
    Cluster-Name     = "qacluster"
    Name             = "qa-cluster vpc"
  }
}

# Fetch the list of subnets in the VPC
data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.dextrus.id
}

# For each subnet, fetch its CIDR range
data "aws_subnet" "subnet" {
  count = length(data.aws_subnet_ids.subnets.ids)
  id    = tolist(data.aws_subnet_ids.subnets.ids)[count.index]
}

#Fetch subnet id details based on cidr-blocks
data "aws_subnets" "dextrus" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dextrus.id]
  }
  filter {
    name   = "cidr-block"
    values = var.subnet_cidr
  }
  depends_on = [
    module.subnet
  ]
}

#Fetch subnet_id information from the existing cidr range
data "aws_subnets" "subnet_existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dextrus.id]
  }
  filter {
    name   = "cidr-block"
    values = local.cidr_range_existing
  }
}

#Fetch all subnet information from the existing cidr range and get the existing az. 
data "aws_subnet" "az_existing" {
  count = length(data.aws_subnets.subnet_existing.ids)
  id    = tolist(data.aws_subnets.subnet_existing.ids)[count.index]
}

# data "aws_subnet_ids" "example" {
#   vpc_id = data.aws_vpc.dextrus.id
# }

data "aws_security_groups" "private_sg" {
  tags = {
    Name             = "private_sg"
    iac              = "terraform"
    Cluster-Name     = "qacluster"
    Application-Name = "Dextrus"
  }
}

data "aws_security_groups" "public_sg" {
  tags = {
    Name             = "public_sg"
    iac              = "terraform"
    Cluster-Name     = "qacluster"
    Application-Name = "Dextrus"
  }
}

data "aws_security_groups" "dextrus_sg" {
  tags = {
    Name             = "dextrus_sg"
    iac              = "terraform"
    Cluster-Name     = "qacluster"
    Application-Name = "Dextrus"
  }
}

