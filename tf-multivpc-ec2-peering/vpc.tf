module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "vrush-vpc-1"
  cidr = "10.0.0.0/16"
  azs = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  tags = {
    terraform = "true"
  }
}

module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "vrush-vpc-2"
  cidr = "10.1.0.0/16"
  azs = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.1.1.0/24","10.1.2.0/24","10.1.3.0/24"]
  public_subnets = ["10.1.101.0/24","10.1.102.0/24","10.1.103.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  tags = {
    terraform = "true"
  }
}

module "ec2-vpc1" {
  source = "../tf-ec2-example"
  instance_count = 1
  name = "vpc1-ec2-1"
  key_name = "vpc1-ec2-key"
  public_key_path = "~/.ssh/vpc1-ec2-key.pub"
  count  = 1
  vpc_id = module.vpc1.vpc_id
  
  providers = {
    aws = aws
  }
  depends_on = [ module.vpc1 ]
}
module "ec2-vpc2" {
  source = "../tf-ec2-example"
  name = "vpc2-ec2-1"
  instance_count = 1
  key_name = "vpc2-ec2-key"
  public_key_path = "~/.ssh/vpc2-ec2-key.pub"
  count  = 1
  vpc_id = module.vpc2.vpc_id
  
  providers = {
    aws = aws
  }
  depends_on = [ module.vpc2 ]
}

resource aws_vpc_peering_connection "vpc1-vpc2-peering" {
  vpc_id = module.vpc1.vpc_id
  peer_vpc_id = module.vpc2.vpc_id
  auto_accept = true

  tags = {
    Name = "vrush-vpc1-vpc2-peering"
  }
}

 #Routes from VPC1 to VPC2 for VPC1 private subnets
resource "aws_route" "vpc1_to_vpc2" {
  count = length(module.vpc1.private_route_table_ids)
  route_table_id            = module.vpc1.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc2.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2-peering.id
}

# Routes from VPC2 to VPC1 for VPC2 private subnets
resource "aws_route" "vpc2_to_vpc1" {
  count = length(module.vpc2.private_route_table_ids)
  route_table_id            = module.vpc2.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2-peering.id
}

# Routes from VPC1 to VPC2 for VPC1 public subnets
resource "aws_route" "vpc1_to_vpc2_public" {
  count = length(module.vpc1.public_route_table_ids)
  route_table_id            = module.vpc1.public_route_table_ids[count.index]
  destination_cidr_block    = module.vpc2.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2-peering.id
}
  

  
# Routes from VPC2 to VPC1 for VPC2 public subnets
resource "aws_route" "vpc2_to_vpc1_public" {
  count = length(module.vpc2.public_route_table_ids)
  route_table_id            = module.vpc2.public_route_table_ids[count.index]
  destination_cidr_block    = module.vpc1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2-peering.id
}