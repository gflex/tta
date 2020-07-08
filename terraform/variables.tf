variable "vpc_subnet" {
  default = "vpc_subnet"
}

variable "aws_region" {
  default = "aws_region"
}
variable "applicant" {
  default = "applicant"
}

variable "project" {
  default = "project"
}

locals {
  common_tags = {
    applicant = var.applicant
    project   = var.project
  }
}

variable "public_nets" {
  default = "public_nets"
}

variable "private_nets" {
  default = "private_nets"
}

variable "db_inst_type" {
  description = "Instance type for DB host"
  default     = "t2.micro"
}

variable "app_inst_type" {
  description = "ec2 insance type for the web servers"
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
