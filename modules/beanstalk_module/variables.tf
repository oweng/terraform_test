variable "application_name" {
  description = "Name of the application"
}
variable "environment" {
  description = "Name of the environment staging|prod|etc"
}

variable "vpc_id" {
  description = "VPC to run in"
}

variable "private_subnets" {
  description = "Subnets to run in"
  type        = "list"
}

variable "public_subnets" {
  description = "Subnets to run in"
  type        = "list"
}

variable "instance_type" {
  description = "EC2 Instance."
  default     = "t2.micro"
}

variable "application_version" {
  description = "code version to use for deployment"
  default     = "latest"
}

variable "asg_max_size" {
  description = "Number of instances to run."
  default     = "1"
}

variable "healthcheck_url" {
  description = "Endpoint to check the app is up."
}

variable "port" {
  description = "The port the app should listen on."
}

variable "application_stack_name" {
  description = "name of beanstalk image to use"
}

variable "s3_bucket_name" {
  description = "name of S3 bucket for code"
}

variable "instance_profile_name" {
  description = "Instance profile to use"
}

variable "cloudwatch_logs_enabled" {
  description = "whether or not to have logs go to CloudWatch"
  default     = "true"
}

variable "log_retention_days" {
  description = "days to keep CloudWatch logs"
  default     = "7"
}
