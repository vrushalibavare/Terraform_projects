variable "name" {
  type = string
  description = "name of the app"
}

variable instance_type {
  type = string
  description = "EC2 instance type"
  default = "t2.micro"
}
 variable "key_name" {
  type = string
  description = "SSH key name"
   
 }

variable "user_data" {
  type        = string
  description = "User data script for the EC2 instance"
  default     = ""
}