provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12.26"
  required_providers {
    aws      = ">= 2.68"
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

