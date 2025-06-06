module "rds_security_group" {
  # This module is used to create a security group for the rds
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = data.aws_vpc.selected.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL port"
      cidr_blocks = data.aws_vpc.selected.cidr_block
    }
  ]

  tags = { 
    terraform = "true"
    Name        = "${var.name}-rds-sg"
  }
}

module "lambda_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name}-lambda-sg"
  description = "Security group for Lambda function"
  vpc_id      = data.aws_vpc.selected.id

  # Outbound rule to RDS security group on port 3306
  egress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "MySQL access to RDS"
      source_security_group_id = module.rds_security_group.security_group_id
    }
  ]

  tags = {
    terraform = "true"
    Name      = "${var.name}-lambda-sg"
  }

  depends_on = [module.rds_security_group]
}

module "rds" {
  source = "terraform-aws-modules/rds/aws"
  identifier = "${var.name}-rds"
  engine = "mysql"
  engine_version = "8.0"
  major_engine_version = "8.0"
  family = "mysql8.0"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  max_allocated_storage = 22
  storage_encrypted = false
  db_name = var.db_name
  
  username = "admin"
  # Use a secure way to store the password, such as AWS Secrets Manager or SSM Parameter Store
  port = "3306"
  create_db_subnet_group = false
  db_subnet_group_name = data.aws_db_subnet_group.database.name
  vpc_security_group_ids = [module.rds_security_group.security_group_id]
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    terraform = "true"
    Name      = "${var.name}-rds"
  }
  
  depends_on = [module.rds_security_group]
}

module "lambda" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = "${var.name}-lambda-rds"
  description = "Lambda function to connect to RDS"
  handler = "lambda_function.lambda_handler"

  runtime = "python3.13"
  
  create_package = false
  local_existing_package = "${path.module}/lambda_function.zip"
 
  vpc_subnet_ids = data.aws_subnets.private.ids
  vpc_security_group_ids = [module.lambda_security_group.security_group_id]
  attach_network_policy = true
  
  # Environment variables will be supplied from the console
  tags = {
    terraform = "true"
    Name      = "${var.name}-lambda"
  }
  
  # Explicit dependency to ensure proper destruction order
  depends_on = [module.lambda_security_group, module.rds]
}


# Null resource to help manage dependencies during destroy
resource "null_resource" "dependency_setter" {
  triggers = {
    lambda_arn = module.lambda.lambda_function_arn
  }

  # This ensures the null resource is created after Lambda and destroyed before Lambda
  depends_on = [module.lambda]
}