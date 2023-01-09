provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = "~>1"
  required_providers {
    aws = {
      version = "~>4"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "test-rbt-gvi-tf-remote-state-bucket"
    key     = "state/gvi/dev/"
    region  = "eu-west-1"
    encrypt = true
  }
}
