#######
# Setting up a bucket for Terraform State and a very small dynamodb table
# to avoid any state issues with multiple runs writing to the same state file
#
# Why global?  since this will be used for the entire project, and will more than
# likely will be ran once, I like to keep these separate from more "common"
# terraform jobs
#######

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "s3.state.bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform-locks-state" {
  name           = "terraform-locks"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}
