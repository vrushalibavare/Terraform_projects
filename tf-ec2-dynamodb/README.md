# EC2 and DynamoDB Integration Project

This project demonstrates how to create an EC2 instance with access to a DynamoDB table using Terraform modules.

## Architecture

- EC2 instance with SSH access
- DynamoDB table with configurable attributes
- IAM role and policy for EC2 to access DynamoDB

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var="name_prefix=myapp"

# Apply the configuration
terraform apply -var="name_prefix=myapp"
```

## Variables

| Name | Description | Default |
|------|-------------|---------|
| name_prefix | Prefix for resource names | demo |
| instance_type | EC2 instance type | t2.micro |
| key_name | SSH key name | vrush |

## Outputs

| Name | Description |
|------|-------------|
| ec2_public_ip | Public IP of the EC2 instance |
| ec2_public_dns | Public DNS of the EC2 instance |
| dynamodb_table_name | Name of the DynamoDB table |
| dynamodb_table_arn | ARN of the DynamoDB table |