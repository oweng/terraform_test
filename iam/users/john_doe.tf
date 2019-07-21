provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "s3.state.bucket"
    key    = "iam/users/john_doe/terraform.tfstate"
    region = "us-east-1"
    encrypt = "true"
    dynamodb_table = "terraform-locks"
  }
}

resource "aws_iam_user" "john_doe" {
  name          = "john_doe"
  path          = "/"
  force_destroy = "true"
}

resource "aws_iam_user_login_profile" "john_doe" {
  user                    = "john_doe"
  password_length         = 15
  password_reset_required = "true"
  pgp_key                 = "pgp_pub_key/base64encoded"

}

output "user_secret" {
value = "${aws_iam_user_login_profile.john_doe.encrypted_password}"
}
