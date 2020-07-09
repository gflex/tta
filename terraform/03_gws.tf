# Create Internet gateway for inbound traffic
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ "Name" : "${var.project}_igw" }, local.common_tags)
}


## allocate EIP for APP net NGW
resource "aws_eip" "eip_nat_gw" {
  count = length(data.aws_availability_zones.available.names)
  vpc   = true
  tags  = merge({ "Name" : "eip_${substr(data.aws_availability_zones.available.names[count.index], -1, 1)}" }, local.common_tags)
}


# Create NAT GW for outbound traffic

resource "aws_nat_gateway" "nat_gw" {
  count         = length(aws_subnet.public_subnets)
  allocation_id = aws_eip.eip_nat_gw[count.index].id #associate former allocated EIP
  subnet_id     = aws_subnet.public_subnets[count.index].id
  depends_on    = [aws_internet_gateway.gw]
  tags          = merge({ "Name" : "nat_gw_${substr(aws_subnet.public_subnets[count.index].availability_zone,-1,1)}" }, local.common_tags)
}
