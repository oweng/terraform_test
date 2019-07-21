
output "application_environment_name" {
  value       = "${module.ec2_beanstalk.name}"
  description = "Name"
}

output "application_cname" {
  value       = "${module.ec2_beanstalk.elb_dns_name}"
  description = "Application CNAME"
}

output "application_name" {
  value       = "${module.ec2_beanstalk.application}"
  description = "ELB technical host"
}
