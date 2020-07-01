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