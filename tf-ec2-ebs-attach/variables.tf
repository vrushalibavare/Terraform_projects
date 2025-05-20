variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "vrush-2.7-tf"
  
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
  
}

variable "key_name" {
  type        = string
  description = "SSH key name"
  default     = "vrush-2.7-tf"
  
}