provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "s3.state.bucket"
    key    = "iam/groups/observers/terraform.tfstate"
    region = "us-east-1"
    encrypt = "true"
    dynamodb_table = "terraform-locks"
  }
}

resource "aws_iam_group" "observers" {
  name = "observers"
  path = "/"
}


resource "aws_iam_policy" "observers_policy" {
  name   = "observers_cloudwatch_policy"
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Action":[
        "logs:Describe*",
        "logs:Get*",
        "logs:TestMetricFilter",
        "logs:FilterLogEvents"
      ],
      "Effect":"Allow",
      "Resource":"*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "observers_iam_attach" {
  name = "observers-attachment"
  groups = ["${aws_iam_group.observers.name}"]
  policy_arn = "${aws_iam_policy.observers_policy.arn}"
}

resource "aws_iam_policy_attachment" "observers_pass_change" {
  name = "observers-pass-change-attachment"
  groups = ["${aws_iam_group.observers.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_group_membership" "observers_users_attach" {
  name = "observers"
  users = [
    "john_doe"
  ]
  group = "${aws_iam_group.observers.name}"
}
