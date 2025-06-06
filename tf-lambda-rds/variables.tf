variable "name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "vrush-tf"
}

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
  default     = "vrushtfdb" 
  
}