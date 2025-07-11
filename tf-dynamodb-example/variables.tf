variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to be created."
  type        = string
  default     = "url-shortener"
  
}

variable region {
  description = "The AWS region where the DynamoDB table will be created."
  type        = string
  default     = "ap-southeast-1"
} 