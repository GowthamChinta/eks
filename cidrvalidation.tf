# variable "desired_cidr_range" {
#   type = string
#   default = "10.0.6.0/24"
# }

# # Fetch the list of subnets in the VPC
# data "aws_subnet_ids" "subnets" {
#   vpc_id = data.aws_vpc.dextrus.id
# }

# # For each subnet, fetch its CIDR range
# data "aws_subnet" "subnet" {
#     count = length(data.aws_subnet_ids.subnets.ids)
#     id = tolist(data.aws_subnet_ids.subnets.ids)[count.index]
# }

# Check if the desired CIDR range is available
# locals {
#   cidr_range_available = [
#   # Iterate over the list of subnets and check if the desired CIDR range overlaps with any of them
#   for subnet in data.aws_subnet.subnet : setsubtract(var.subnet_cidr, split(",", subnet.cidr_block))
#   #for subnet in data.aws_subnet.subnet : contains(var.subnet_cidr, subnet.cidr_block)
#   #for subnet in data.aws_subnet.subnet : subnet.cidr_block == join(", ", var.subnet_cidr)
#   #[for i in var.subnet_cidr : i ]
#   ]
# }

# locals {
#   cidr_range_available  = flatten([
#     setsubtract(var.subnet_cidr, [for subnet in data.aws_subnet.subnet : subnet.cidr_block])
#   ])
# }

# output "cidr_range_existing" {
#   value = local.cidr_range_available 
# }

# locals {
#   cidr_range_available = [
#     flatten(setsubtract(var.subnet_cidr,local.cidr_range_existing))
#   ]
# }

# output "cidr_range_available" {
#   value = local.cidr_range_available
# }
# locals {
#   valid_cidr_block = [
#     setintersection(local.cidr_range_available)
#   ]
# }
# output "cidr_range_available" {
#   value = local.cidr_range_available
# } 

# output "valid_cidr_block" {
#   value = setintersection(local.valid_cidr_block)
# }


# resource "aws_subnet" "new_subnet" {
#   count = contains(local.cidr_range_available, true) ? 0 : 1
#   vpc_id     = data.aws_vpc.dextrus.id
#   cidr_block = var.subnet_cidr
#   availability_zone = "us-west-2b"
# }
