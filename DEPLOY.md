# Terraform Test:
The goal of this project was to come up with a couple solutions for deploying services via Terraform to AWS.  That being said the 3 scenerios are:
* create a Node Elastic Beanstalk environment that uses ec2 for its system
* create a Node Elastic Beanstalk environment that uses Docker (in the exercise I used a single container image)
* create an IAM user and an IAM Group which has read-only access to CloudWatch Logs

### Terraform code itself:
I tried to comment as much as possible in the code as to where my thought process was in doing what I did.  A couple of points before digging in...
1. Modules.  I did write one module for the beanstalk environments as it seemed the easier way to proceed.  It's not a be all end all module.  Pretty specific for what I was trying to achieve here.
2. Variables.  I tried to use variables as much as possible as I thought it would be easier to deploy something if there were just a few variable changes vs needing to find things inside the actual code.
3. Docker.  I compiled this locally on my box with a super simple Dockerfile, and then pushed the image to an ECR repository, so this way everything stayed in AWS.

### Terraform Setup:

To begin, The first thing to do is to setup a bucket for storing the Terraform State.  Due to collaboration as well as keeping things safe, I like to use a combination of S3 and Dynamodb to make sure state can't be altered while multiple people could be deploying. these main.tf's would need to be edited for the "bucket":
```terraform_test/global/main.tf
terraform_test/beanstalk/docker/main.tf
terraform_test/beanstalk/ec2/main.tf
terraform_test/iam/groups/observers.tf
terraform_test/iam/users/john_doe.tf
```

Variables needed to be set in global/main.tf|values
--------------------------------------------|------
bucket| name of S3 bucket to create or use
name (in dynamodb block)|if you want to change the default name of your table

While in the "global" directory you just need to run:
```
terraform init
terrafom plan
terraform apply
```

### Terraform Beanstalk EC2:
Deployment of the EC2 environment is pretty straight forward.  The node code is inside the `source` directory for this deployment.  I set it up to zip the code up and then deploy basically from S3 while the stack is being built.  If you want to update the code, you can make your changes there, but then you also need to change the `beanstalk_module_application_version` var below. `cd terraform_test/beanstalk/ec2`

###### Variables:
Variable name|defaults/value(s)|Explanation
-------------|-------|-----------
eb_s3_bucket|(name of s3 bucket)|s3 bucket for elasticbeanstalk deployment
eb_ec2_config|/source|default for the source directory where code will be archived from
eb_archive_zip|source/ec2_node.zip|output directory and archive name
eb_s3_archive|ec2/node/development/ec2_node.zip|object name being uploaded to above s3 bucket
beanstalk_module_application_version|v1|tag used on the archive created above
beanstalk_module_application_name|web-ec2|the Beanstalk application name
beanstalk_module_application_stack_name|64bit Amazon Linux 2018.03 v4.9.2 running Node.js|solution stack name
beanstalk_module_environment|development|name of Beanstalk environment
beanstalk_module_instance_type|t2.micro|instance size to use for environment
beanstalk_module_asg_max_size|1|auto scaling group max number of instances to run
beanstalk_module_instance_profile_name|beanstalk_ec2_profile|this is the default instance profile built in the main.tf
beanstalk_module_vpc_id|(yur vpc id)|VPC id you want to deploy to
beanstalk_module_public_subnets|(subnet(s) list| list of subnets to use for ELB
beanstalk_module_private_subnets|(subnet(s) list| list of subnets to use for ec2 instances
beanstalk_module_healthcheck_url|"/"|default healthcheck URI
beanstalk_module_port|80|ELB listen port

After these are set, should be able to do the normal:
```
terraform init
terrafom plan
terraform apply
```
Output of the Applcation name, environment, and web URL should be printed to your screen

### Terraform Beanstalk Docker:
Deployment of the Docker environment is pretty straight forward as well.  The main difference is the source code is not in the terraform code directory.  Since it's a container, we would need to push the updated container to ECR prior to trying to redeploy.  in the `source` directory instead is a file `Dockerrun.aws.json` that controls the deployment of where and what container to use. `cd terraform_test/beanstalk/docker`

###### Variables:
Variable name|defaults/value(s)|Explanation
-------------|-------|-----------
eb_s3_bucket|(name of s3 bucket)|s3 bucket for elasticbeanstalk deployment
eb_ec2_config|source/Dockerrun.aws.json|default for the source directory where code will be archived from
eb_archive_zip|source/docker_node.zip|output directory and archive name
eb_s3_archive|ec2/node/development/docker_node.zip|object name being uploaded to above s3 bucket
beanstalk_module_application_version|latest|tag used on the archive created above
beanstalk_module_application_name|web-docker|the Beanstalk application name
beanstalk_module_application_stack_name|64bit Amazon Linux 2018.03 v2.12.14 running Docker 18.06.1-ce|solution stack name (single container)
beanstalk_module_environment|development|name of Beanstalk environment
beanstalk_module_instance_type|t2.micro|instance size to use for environment
beanstalk_module_asg_max_size|1|auto scaling group max number of instances to run
beanstalk_module_instance_profile_name|beanstalk_docker_profile|this is the default instance profile built in the main.tf
beanstalk_module_vpc_id|(your vpc id)|VPC id you want to deploy to
beanstalk_module_public_subnets|(subnet(s) list| list of subnets to use for ELB
beanstalk_module_private_subnets|(subnet(s) list| list of subnets to use for ec2 instances
beanstalk_module_healthcheck_url|"/"|default healthcheck URI
beanstalk_module_port|80|ELB listen port

After these are set, should be able to do the normal(again...):
```
terraform init
terrafom plan
terraform apply
```
Output of the Applcation name, environment, and web URL should be printed to your screen

### IAM USER, Group, and Policy creation
I didn't create a module for this just because of the sensitivity of IAM in my opinion.  I think this is pretty straight forward.  Just need to do the steps in order.

1. create user
2. create group and policy (this is done in the same main.tf)

###### Creating the user
In this case I like to make sure, even if it's a copy, that everything in the file is exactly what I want.  That being said, I just created a single "john_doe" user and using my own pgp public key (this needs to be echo'd through base64 to be used in the Terraform code) to get the password.  Otherwise, same as above, you will see the code at the top for this to be written to it's own state file, so `cd terraform_test/iam/users`, then it's just:
```
terraform init
terrafom plan
terraform apply
```
Output of the pgp encrypted password will be displayed to your screen.

###### Creating the Group and IAM Policy for the group
I am getting long winded here..  I have seen IAM policies/roles/groups get out of hand (couple hunder files in a single directory).  So in this case, I thought it might be best to keep the policy specific for this group to be in the same main.tf as the group creation.  This way it cuts down on the clutter and hopefully will make things easier to find.  Like the IAM user, `cd terraform_test/iam/groups` then:
```
terraform init
terrafom plan
terraform apply
```
