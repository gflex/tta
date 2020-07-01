# first create the vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_subnet
  enable_dns_hostnames = true
  tags                 = merge({ "Name" = "vpc_${var.project}" }, local.common_tags)
}




