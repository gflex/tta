provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = "~> 1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project}-${var.applicant}-tf-remote-state-bucket"
  versioning {
    enabled = true
  }
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = local.common_tags
}

