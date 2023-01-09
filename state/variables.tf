
variable "aws_region" {
  default = "aws_region"
}
variable "user" {
  default = "user"
}

variable "project" {
  default = "project"
}

locals {
  common_tags = {
    user    = var.user
    project = var.project
  }
}
