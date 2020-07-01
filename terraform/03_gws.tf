# Create Internet gateway for inbound traffic
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ "Name" : "${var.project}_igw" }, local.common_tags)
}


## allocate EIP for APP net NGW
resource "aws_eip" "eip_nat_gw" {
  vpc  = true
  tags = merge({ "Name" : "${var.project}_eip_nat" }, local.common_tags)
}


# Create NAT GW for outbound traffic

resource "aws_nat_gateway" "app_nat_gw" {
  allocation_id = aws_eip.eip_nat_gw.id #associate former allocated EIP
  subnet_id     = module.public_subnets.subnets_ids.0
  depends_on    = [aws_internet_gateway.gw]
  tags          = merge({ "Name" : "${var.project}_nat_gw" }, local.common_tags)
}
