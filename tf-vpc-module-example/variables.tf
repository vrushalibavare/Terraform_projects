variable "region" {
  description = "The AWS region to deploy the VPC in"
  type        = string
  default     = "ap-southeast-1"
  
}

variable "name" {
  description = "The name of the VPC"
  type        = string
  default     = "vrushali-vpc"
  
}