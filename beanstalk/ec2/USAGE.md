# Usage
<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| beanstalk\_module\_application\_name | n/a | `string` | `"web-ec2"` | no |
| beanstalk\_module\_application\_stack\_name | n/a | `string` | `"64bit Amazon Linux 2018.03 v4.9.2 running Node.js"` | no |
| beanstalk\_module\_application\_version | code version to use for deployment | `string` | `"v1"` | no |
| beanstalk\_module\_asg\_max\_size | n/a | `string` | `"1"` | no |
| beanstalk\_module\_environment | n/a | `string` | `"development"` | no |
| beanstalk\_module\_healthcheck\_url | n/a | `string` | `"/"` | no |
| beanstalk\_module\_instance\_profile\_name | n/a | `string` | `"beanstalk_ec2_profile"` | no |
| beanstalk\_module\_instance\_type | n/a | `string` | `"t2.micro"` | no |
| beanstalk\_module\_port | n/a | `string` | `"80"` | no |
| beanstalk\_module\_private\_subnets | n/a | `list` | <pre>[<br>  "subnet-xxxxxxx",<br>  "subnet-xxxxxxx"<br>]</pre> | no |
| beanstalk\_module\_public\_subnets | n/a | `list` | <pre>[<br>  "subnet-xxxxxxx",<br>  "subnet-xxxxxxx"<br>]</pre> | no |
| beanstalk\_module\_vpc\_id | n/a | `string` | `"vpc-2886c14c"` | no |
| eb\_archive\_zip | n/a | `string` | `"source/ec2_node.zip"` | no |
| eb\_ec2\_config | n/a | `string` | `"source/"` | no |
| eb\_s3\_archive | n/a | `string` | `"ec2/node/development/ec2_node.zip"` | no |
| eb\_s3\_bucket | n/a | `string` | `"bucket_name"` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_cname | Application CNAME |
| application\_environment\_name | Name |
| application\_name | ELB technical host |

<!--- END_TF_DOCS --->
