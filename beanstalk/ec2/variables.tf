####
# Vars file.  Setting perhaps some obvious ones.  Hopefully better than
# setting some of these in the main.tf so we can avoid potential issues there
####

variable "eb_s3_bucket" {
  default = "bucket_name"
}

variable "eb_ec2_config" {
  default = "source/"
}

variable "eb_archive_zip" {
  default = "source/ec2_node.zip"
}

variable "eb_s3_archive" {
  default = "ec2/node/development/ec2_node.zip"
}

variable "beanstalk_module_application_version" {
  description = "code version to use for deployment"
  default     = "v1"
}

variable "beanstalk_module_application_name" {
  default = "web-ec2"
}

variable "beanstalk_module_application_stack_name" {
  default = "64bit Amazon Linux 2018.03 v4.9.2 running Node.js"
}

variable "beanstalk_module_environment" {
  default = "development"
}
variable "beanstalk_module_instance_type" {
  default = "t2.micro"
}

variable "beanstalk_module_asg_max_size" {
  default = "1"
}

variable "beanstalk_module_instance_profile_name" {
  default = "beanstalk_ec2_profile"
}

variable "beanstalk_module_vpc_id" {
  default = "vpc-2886c14c"
}

variable "beanstalk_module_public_subnets" {
  default = ["subnet-xxxxxxx", "subnet-xxxxxxx"]
}

variable "beanstalk_module_private_subnets" {
  default = ["subnet-xxxxxxx", "subnet-xxxxxxx"]
}

variable "beanstalk_module_healthcheck_url" {
  default = "/"
}

variable "beanstalk_module_port" {
  default = "80"
}
