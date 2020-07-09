provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12.26"
  required_providers {
    template = ">= 2.1"
    aws      = ">= 2.68"
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
