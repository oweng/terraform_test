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
| beanstalk\_module\_application\_name | n/a | `string` | `"web-docker"` | no |
| beanstalk\_module\_application\_stack\_name | n/a | `string` | `"64bit Amazon Linux 2018.03 v2.12.14 running Docker 18.06.1-ce"` | no |
| beanstalk\_module\_application\_version | code version to use for deployment | `string` | `"latest"` | no |
| beanstalk\_module\_asg\_max\_size | n/a | `string` | `"1"` | no |
| beanstalk\_module\_environment | n/a | `string` | `"development"` | no |
| beanstalk\_module\_healthcheck\_url | n/a | `string` | `"/"` | no |
| beanstalk\_module\_instance\_profile\_name | n/a | `string` | `"beanstalk_docker_profile"` | no |
| beanstalk\_module\_instance\_type | n/a | `string` | `"t2.micro"` | no |
| beanstalk\_module\_port | n/a | `string` | `"80"` | no |
| beanstalk\_module\_private\_subnets | n/a | `list` | <pre>[<br>  "subnet-xxxxxxx",<br>  "subnet-xxxxxxx"<br>]</pre> | no |
| beanstalk\_module\_public\_subnets | n/a | `list` | <pre>[<br>  "subnet-xxxxxxx",<br>  "subnet-xxxxxxx"<br>]</pre> | no |
| beanstalk\_module\_vpc\_id | n/a | `string` | `"vpc-xxxxxxx"` | no |
| eb\_archive\_zip | n/a | `string` | `"source/docker_node.zip"` | no |
| eb\_docker\_config | n/a | `string` | `"source/Dockerrun.aws.json"` | no |
| eb\_s3\_archive | n/a | `string` | `"docker/node/development/docker_node.zip"` | no |
| eb\_s3\_bucket | n/a | `string` | `"s3_bucket"` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_cname | Application CNAME |
| application\_environment\_name | Name |
| application\_name | ELB technical host |

<!--- END_TF_DOCS --->
