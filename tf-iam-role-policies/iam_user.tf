locals {
  user_name = "${var.name_prefix}-tf-user"
  description= "User with permissions to create, view, and delete EC2 instances, create/view S3 buckets, and view RDS instances"
}

# Create IAM user
resource "aws_iam_user" "user" {
  name = local.user_name
  tags = {
    Description = "User with permissions to create, view, and delete EC2 instances, create/view S3 buckets, and view RDS instances"
  }
}

# Create IAM policy for EC2 permissions
resource "aws_iam_policy" "ec2_policy" {
  name        = "${local.user_name}-ec2-policy"
  description = "Policy to create, view, and delete EC2 instances"
  policy = data.aws_iam_policy_document.ec2_policy.json
}

resource "aws_iam_policy" "s3_policy" {
  name        = "${local.user_name}-s3-policy"
  description = "Policy to create and view S3 buckets"
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_policy" "rds_policy" {
  name        = "${local.user_name}-rds-policy"
  description = "Policy to only view RDS instances"
  policy = data.aws_iam_policy_document.rds_policy.json
}

# Attach policies to user
resource "aws_iam_user_policy_attachment" "ec2_policy_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_user_policy_attachment" "s3_policy_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_user_policy_attachment" "rds_policy_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.rds_policy.arn
}



# Output user details
output "iam_user_name" {
  value = aws_iam_user.user.name
  description = "The IAM user name"
}

