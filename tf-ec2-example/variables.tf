variable "name" {
  type = string
  description = "name of the app"
  default = "vrush-tf-ec2"
}

variable instance_type {
  type = string
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "key_name" {
  type = string
  description = "SSH key name"
  default = "ec2-key"
}

variable instance_count {
  type        = number
  description = "Number of EC2 instances to create"
  default     = 1
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key file for SSH access"
  default     = "~/.ssh/ec2-key.pub"
}

variable "public_subnet"{
  type = bool
  description = "Whether to use a public subnet for the EC2 instance"
  default = true
}

variable "vpc_id" {
  type = string
  description = "ID of the VPC to launch instances in"
  default = "vpc-007578610a8dcae22" # Deafault ID of vrushali-vpc
}