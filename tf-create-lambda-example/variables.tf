variable "region" {
  default = "ap-southeast-1"  # Default AWS region  
}

variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
  default     = "vrush-tf-lambda-example"  # Default name for the Lambda function
  
}