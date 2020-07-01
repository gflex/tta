// add pub net default gateway via internet gateway
//Create routing table for public subnets
module "pub_net_routing_table" {
  source        = "./modules/routing"
  m_vpc_id      = aws_vpc.vpc.id
  m_subn_count  = length(module.public_subnets.subnets_ids)
  m_subnets_ids = module.public_subnets.subnets_ids
  m_rt_name     = "${var.project}_pub_nets_rt_tbl"
  m_tags        = merge({ "Name" : "${var.project}_pub_net_rt" }, local.common_tags)
}

// add pub net default gateway via internet gateway
resource "aws_route" "pub_net_dg" {
  route_table_id         = module.pub_net_routing_table.rt_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  depends_on             = [module.pub_net_routing_table.rt_id]
}


// create routing table for App network (private)
module "app_net_routing_table" {
  source        = "./modules/routing"
  m_vpc_id      = aws_vpc.vpc.id
  m_subnets_ids = module.app_subnets.subnets_ids
  m_rt_name     = "${var.project}_app_rt_tbl"
  m_subn_count  = length(module.app_subnets.subnets_ids)
  m_tags        = merge({ "Name" : "${var.project}_app_net_rt" }, local.common_tags)
}

// add default route for wordpress net to wordpress nat gateway
resource "aws_route" "app_net_dg" {
  route_table_id         = module.app_net_routing_table.rt_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat_gw.id
  depends_on             = [module.app_net_routing_table.rt_id]
}

// Routing table for RDS network
module "rds_net_routing_table" {
  source        = "./modules/routing"
  m_vpc_id      = aws_vpc.vpc.id
  m_subnets_ids = module.rds_subnets.subnets_ids
  m_rt_name     = "${var.project}_rds_rt_tbl"
  m_subn_count  = length(module.rds_subnets.subnets_ids)
  m_tags        = merge({ "Name" : "${var.project}_rds_net_rt" }, local.common_tags)
}

resource "aws_route" "rds_net_dg" {
  route_table_id         = module.rds_net_routing_table.rt_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat_gw.id
  depends_on             = [module.app_net_routing_table.rt_id]
}
