variable "name_prefix" {
  description = "Prefix for the IAM user and policies"
  type        = string
  default     = "lambda-url-shortener"
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1" # Change to your desired region
  
}

variable "dynamodb_table" {
  description = "Name of the DynamoDB table to be used by the Lambda function"
  type        = string
  default     = "url-shortener-table" # Change to your desired table name
  
}