# DynamoDB Book Inventory Table

This Terraform configuration creates a DynamoDB table named "vrush-bookinventory" for storing book inventory information.

## Table Structure

- Table Name: vrush-bookinventory
- Primary Key: BookId (String)
- Capacity Mode: On-demand (PAY_PER_REQUEST)

## Usage

```bash
# Initialize Terraform
terraform init

# Preview the changes
terraform plan

# Apply the changes
terraform apply

# Destroy resources when no longer needed
terraform destroy
```