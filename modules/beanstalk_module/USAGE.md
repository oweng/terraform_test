# Usage
<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_name | Name of the application | `any` | n/a | yes |
| application\_stack\_name | name of beanstalk image to use | `any` | n/a | yes |
| application\_version | code version to use for deployment | `string` | `"latest"` | no |
| asg\_max\_size | Number of instances to run. | `string` | `"1"` | no |
| cloudwatch\_logs\_enabled | whether or not to have logs go to CloudWatch | `string` | `"true"` | no |
| environment | Name of the environment staging\|prod\|etc | `any` | n/a | yes |
| healthcheck\_url | Endpoint to check the app is up. | `any` | n/a | yes |
| instance\_profile\_name | Instance profile to use | `any` | n/a | yes |
| instance\_type | EC2 Instance. | `string` | `"t2.micro"` | no |
| log\_retention\_days | days to keep CloudWatch logs | `string` | `"7"` | no |
| port | The port the app should listen on. | `any` | n/a | yes |
| private\_subnets | Subnets to run in | `list` | n/a | yes |
| public\_subnets | Subnets to run in | `list` | n/a | yes |
| s3\_bucket\_name | name of S3 bucket for code | `any` | n/a | yes |
| vpc\_id | VPC to run in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| application | The Elastic Beanstalk Application specified for this environment. |
| elb\_dns\_name | ELB technical host |
| name | Name |

<!--- END_TF_DOCS --->
