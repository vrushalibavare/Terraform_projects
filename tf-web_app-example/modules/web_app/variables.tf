variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
  
}
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
  
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
   
}

variable "vpc_id" {
  description = "VPC ID where the resources will be created"
  type        = string
  
}

variable "public_subnet" {
  description = "Whether to create resources in a public subnet"
  type        = bool
  default     = true
  
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
  default     = ""
  
}



