# Setting eb stuff


####
# Not super pleased with this, but since it takes a little time for the application version to be
# pushed to s3, this should be enough time for that to finsh
####

resource "null_resource" "before" {
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 20"
  }
  triggers = {
    "before" = "${null_resource.before.id}"
  }
}

resource "aws_elastic_beanstalk_application" "in_eb_application" {
  name        = "${var.application_name}"
  description = "${var.application_name}"
}

resource "aws_elastic_beanstalk_environment" "in_eb_environment" {
  depends_on          = ["null_resource.delay"]
  name                = "${var.application_name}-${var.environment}"
  application         = "${aws_elastic_beanstalk_application.in_eb_application.name}"
  solution_stack_name = "${var.application_stack_name}"
  tier                = "WebServer"
  version_label       = "${var.application_version}"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.asg_max_size}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${var.instance_profile_name}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

    setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", var.private_subnets)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", var.public_subnets)}"
}

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "${var.healthcheck_url}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "HTTP:${var.port}${var.healthcheck_url}"
  }

  setting {
    namespace = "aws:elb:listener"
    name      = "InstancePort"
    value     = "${var.port}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "${var.cloudwatch_logs_enabled}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "${var.log_retention_days}"
  }
}
