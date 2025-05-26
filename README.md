# Terraform_projects

CE_10 Terraform project files
description
This project cretes a web app .
The webapp is running on EC2 instances that can be toggled between public and private subnets using the var.pub_subnet variable to true or false.
If the EC2 instances are launched in the private subnet the ensure to configure a NAT GW in the public subnet and disable
assign_public_ip to allow proper routing through natgw.
A load balancer module is called to run in the public subnets and a target group is creted to register the webap ec2 instances.
The load balancer url is then accessed from the browser.
