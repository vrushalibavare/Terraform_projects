module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  

  name = "vrushali-vpc"
  cidr = "10.0.0.0/16"
  azs = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]
  database_subnets = ["10.0.201.0/24","10.0.202.0/24","10.0.203.0/24"]
  create_database_subnet_group = true
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  tags = {
    terraform = "true"
    name     = "vrushali-tf-vpc"
}
}

output "natgwids" {
  value = module.vpc.natgw_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
 
}


output "aws_availability_zones" {
  value = data.aws_availability_zones.available.names
  
}
