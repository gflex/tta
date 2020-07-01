variable "m_subnets_avz" {
  type = map
  description = "availability zone for the subnet"
  default = null
}

variable "m_common_tags" {}

variable "m_vpc_id" {
  description = "VPC id"
}

variable "m_public" {
  type        = bool
  description = "Whether the network is public or not"
}

variable "m_net_def" {
  description = "map of type { name = \"xxx\", cidr = \"w.x.y.z\" }"
}
