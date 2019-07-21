####
# Vars file.  Setting perhaps some obvious ones.  Hopefully better than
# setting some of these in the main.tf so we can avoid potential issues there
####

variable "eb_s3_bucket" {
  default = "s3_bucket"
}

variable "eb_docker_config" {
  default = "source/Dockerrun.aws.json"
}

variable "eb_archive_zip" {
  default = "source/docker_node.zip"
}

variable "eb_s3_archive" {
  default = "docker/node/development/docker_node.zip"
}

variable "beanstalk_module_application_version" {
  description = "code version to use for deployment"
  default     = "latest"
}

variable "beanstalk_module_application_name" {
  default = "web-docker"
}

variable "beanstalk_module_application_stack_name" {
  default = "64bit Amazon Linux 2018.03 v2.12.14 running Docker 18.06.1-ce"
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
  default = "beanstalk_docker_profile"
}

variable "beanstalk_module_vpc_id" {
  default = "vpc-xxxxxxx"
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
