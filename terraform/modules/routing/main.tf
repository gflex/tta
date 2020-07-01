resource "aws_route_table" "rt" {
  vpc_id = var.m_vpc_id
  tags   = var.m_tags
}

resource "aws_route_table_association" "rt_assoc" {
  count          = var.m_subn_count
  route_table_id = aws_route_table.rt.id
  subnet_id      = element(var.m_subnets_ids, count.index)
}