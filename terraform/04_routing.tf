## Public network
##create routing table for public networks
resource "aws_route_table" "pub_routing_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ "Name" : "pub_rtb" }, local.common_tags)
}
#create association pub nets to pub routing table
resource "aws_route_table_association" "pub_routing_table" {
  count          = length(aws_subnet.public_subnets)
  route_table_id = aws_route_table.pub_routing_table.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

## Add routing to Internet for pub net
resource "aws_route" "pub_net_routing" {
  route_table_id         = aws_route_table.pub_routing_table.id
  gateway_id             = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"
}


## Applicaiton network
## Create routing tables
resource "aws_route_table" "app_routing_table" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ "Name" : "app_rt_${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}" }, local.common_tags)
}

resource "aws_route_table_association" "app_routing_table" {
  count          = length(aws_subnet.app_subnets)
  route_table_id = aws_route_table.app_routing_table[count.index].id
  subnet_id      = aws_subnet.app_subnets[count.index].id
}

resource "aws_route" "app_net_route" {
  count                  = length(aws_subnet.app_subnets)
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.app_routing_table[count.index].id
}


## RDS network
## ROuting table
resource "aws_route_table" "rds_routing_table" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ "Name" : "rds_rt_${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}" }, local.common_tags)
}


## Routing association
resource "aws_route_table_association" "rds_routing_table" {
  count          = length(aws_subnet.rds_subnets)
  route_table_id = aws_route_table.rds_routing_table[count.index].id
  subnet_id      = aws_subnet.rds_subnets[count.index].id
}

## NAT gateway
resource "aws_route" "rds_net_route" {
  count                  = length(aws_subnet.rds_subnets)
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.rds_routing_table[count.index].id
}