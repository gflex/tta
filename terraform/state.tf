provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12.25"
  required_providers {
    aws      = ">= 2.60"
    template = ">= 2.1"
  }
}

terraform {
  backend "s3" {
    bucket  = "rbt-task-georgi-ivanov-tf-remote-state-bucket"
    key     = "rbt/global/terraform.state"
    region  = "eu-central-1"
    encrypt = true
  }
}
