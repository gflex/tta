#create public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = var.pub_nets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags                    = merge({ "Name" : "pub_net_${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}" }, local.common_tags)
}

//Create application networkds
resource "aws_subnet" "app_subnets" {
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = var.app_nets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags                    = merge({ "Name" : "app_net_${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}" }, local.common_tags)
}
//create RDS networks
resource "aws_subnet" "rds_subnets" {
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = var.rds_nets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags                    = merge({ "Name" : "rds_net_${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}" }, local.common_tags)

}