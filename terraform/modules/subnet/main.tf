resource "aws_subnet" "subnet" {
  for_each                = var.m_net_def
  vpc_id                  = var.m_vpc_id
  cidr_block              = each.value["cidr"]
  availability_zone       = lookup(var.m_subnets_avz, each.value["avz"])
  map_public_ip_on_launch = var.m_public
  tags                    = merge({ "Name" = each.key }, var.m_common_tags)
}
