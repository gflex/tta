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
    bucket  = ""
    key     = ""
    region  = ""
    encrypt = true
  }
}
