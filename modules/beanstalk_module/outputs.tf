
output "name" {
  value       = "${aws_elastic_beanstalk_environment.in_eb_environment.name}"
  description = "Name"
}

output "elb_dns_name" {
  value       = "${aws_elastic_beanstalk_environment.in_eb_environment.cname}"
  description = "ELB technical host"
}

output "application" {
  description = "The Elastic Beanstalk Application specified for this environment."
  value       = "${aws_elastic_beanstalk_environment.in_eb_environment.application}"
}