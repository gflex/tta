
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
    project = var.project
  }
}
