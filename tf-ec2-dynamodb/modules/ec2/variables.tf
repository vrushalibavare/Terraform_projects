variable "name" {
  type        = string
  description = "Name prefix for resources"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile name to attach to the EC2 instance"
  default     = null
}