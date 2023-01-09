provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = "~>1"
  required_providers {
    template = {
      version = "~>3" 
    }
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
