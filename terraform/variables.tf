variable "vpc_subnet" {}
variable "aws_region" {}
variable "user" {}
variable "project" {}

locals {
  common_tags = {
    user    = var.user
    project = var.project
  }
}

variable "pub_nets" {
  description = "public network whene load balancers will reside"
}
variable "app_nets" {
  description = "application network where web servers reside"
}
variable "rds_nets" {
  description = "network for the DB hosts/services"
}


variable "db_inst_type" {
  description = "Instance type for DB host"
  default     = "t2.micro"
}

variable "app_inst_type" {
  description = "ec2 instance type for the web servers"
  default     = "t2.micro"
}

variable "db_root_user" {
  description = "username for the db"
  default     = "root"
}

variable "db_wp_user" {
  description = "db user for wordpress"
  default     = "wp_db_user"
}

variable "wp_db_name" {
  description = "database for wordpress"
  default     = "wp_db"
}

variable "wp_admin_user" {
  description = "Username of wordpress administrator"
  default     = "wpadmin"
}

variable "wp_root_dir" {
  description = "root dir for wordpress installation"
  default     = "/var/www/html"
}

variable "db_root_dir" {
  description = "database root directory"
  default     = "/var/lib/mysql"
}
