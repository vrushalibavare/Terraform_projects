module "ec2" {
  source              = "./modules/ec2"
  name                = var.name_prefix
  instance_type       = var.instance_type
  key_name            = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  name       = var.name_prefix
  hash_key   = "ISBN"
  attributes = [
    {
      name = "ISBN"
      type = "S"
    }
  ]
}

# Create an IAM role for EC2 to access DynamoDB
resource "aws_iam_role" "ec2_dynamodb_role" {
  name = "${var.name_prefix}-ec2-dynamodb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Create an IAM policy for DynamoDB access
resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.name_prefix}-dynamodb-access"
  description = "Policy to allow EC2 instance to access DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:ListTables",
          "dynamodb:DescribeTable"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = module.dynamodb.table_arn
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "dynamodb_attach" {
  role       = aws_iam_role.ec2_dynamodb_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

# Create an instance profile for the EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_dynamodb_role.name
}