# Not going to use a for_each
resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr)

  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr[count.index]
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "iac"       = "terraform"
    "app"       = "dextrus"
    "component" = "subnet"
  }
}
