locals {
  avz_map = {
    avz1 = data.aws_availability_zones.available.names[0],
    avz2 = data.aws_availability_zones.available.names[1]
  }
}

## Create public subnet for the LB
module "public_subnets" {
  source        = "./modules/subnet"
  m_subnets_avz = local.avz_map
  m_net_def     = var.public_nets
  m_public      = true
  m_vpc_id      = aws_vpc.vpc.id
  m_common_tags = local.common_tags
}
## Create private subnets for web servers

module "app_subnets" {
  source        = "./modules/subnet"
  m_subnets_avz = local.avz_map
  m_net_def     = var.private_nets.app
  m_public      = false
  m_vpc_id      = aws_vpc.vpc.id
  m_common_tags = local.common_tags
}

## Create DB network (RDS) for the DB
module "rds_subnets" {
  source        = "./modules/subnet"
  m_subnets_avz = local.avz_map
  m_net_def     = var.private_nets.rds
  m_public      = false
  m_vpc_id      = aws_vpc.vpc.id
  m_common_tags = local.common_tags
}

