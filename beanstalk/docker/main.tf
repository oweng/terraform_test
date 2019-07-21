####
# Normally I would put IAM related stuff in its own place so policies/roles would
# be more "managed" But for this excersize I didn't want to end up in a rabbit hole..
####


####
# Setting AWS Provider and S3 State location for this application and environment
####

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "s3.state.bucket"
    key    = "beanstalk/docker/node/development/terraform.tfstate"
    region = "us-east-1"
    encrypt = "true"
    dynamodb_table = "terraform-locks"
  }
}
# Create Instance Profile
resource "aws_iam_instance_profile" "docker_beanstalk" {
  name = "beanstalk_docker_profile"
  role = "${aws_iam_role.docker_beanstalk.name}"
}

# Create Role with assume role access
resource "aws_iam_role" "docker_beanstalk" {
  name = "beanstalk_docker_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Docker Beanstalk Policy
resource "aws_iam_role_policy" "docker_beanstalk_policy" {
  name = "docker_beanstalk_policy"
  role = "${aws_iam_role.docker_beanstalk.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "ds:CreateComputer",
        "ds:DescribeDirectories",
        "ec2:DescribeInstanceStatus",
        "logs:*",
        "ssm:*",
        "ec2messages:*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

####
# Setting our S3 bucket for code deployments.  Not putting this in the module below 
# because it can cause some timing issues when creating the application to be deployed
####

resource "aws_s3_bucket" "in_s3_bucket" {
  bucket = "${var.eb_s3_bucket}"
}

####
# setting up the deployment creating a zip of our Docker info
####
data "archive_file" "code_archive" {
  type        = "zip"
  source_file = "${var.eb_docker_config}"
  output_path = "${var.eb_archive_zip}"
}

resource "aws_s3_bucket_object" "node_docker_config" {
  depends_on = ["aws_s3_bucket.in_s3_bucket"]
  key        = "${var.eb_s3_archive}"
  bucket     = "${var.eb_s3_bucket}"
  source     = "${var.eb_archive_zip}"
}

resource "aws_elastic_beanstalk_application_version" "latest" {
  depends_on  = ["aws_s3_bucket_object.node_docker_config"]
  name        = "${var.beanstalk_module_application_version}"
  application = "${var.beanstalk_module_application_name}"
  description = "Version ${var.beanstalk_module_application_version} of app web: node_app"
  bucket      = "${var.eb_s3_bucket}"
  key         = "${var.eb_s3_archive}"
}

####
# I went with a generic module so I can hopefully use this across related apps  this
# is definitely not a "should work" for EVERY beanstalk app though.  More pointed
# at a docker then dedicated server scenario
###

module "docker_beanstalk_dev" {
  source                 = "../../modules/beanstalk_module"
  application_name       = "${var.beanstalk_module_application_name}"
  application_stack_name = "${var.beanstalk_module_application_stack_name}"
  environment            = "${var.beanstalk_module_environment}"
  instance_type          = "${var.beanstalk_module_instance_type}"
  asg_max_size           = "${var.beanstalk_module_asg_max_size}"
  instance_profile_name  = "${var.beanstalk_module_instance_profile_name}"
  vpc_id                 = "${var.beanstalk_module_vpc_id}"
  public_subnets         = "${var.beanstalk_module_public_subnets}"
  private_subnets        = "${var.beanstalk_module_private_subnets}"
  healthcheck_url        = "${var.beanstalk_module_healthcheck_url}"
  port                   = "${var.beanstalk_module_port}"
  s3_bucket_name         = "${var.eb_s3_bucket}"
  application_version    = "${var.beanstalk_module_application_version}"
}
