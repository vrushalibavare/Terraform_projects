locals {
  name_prefix = var.name_prefix
}

resource "aws_iam_role" "role_example" {
  name = "${local.name_prefix}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


#Option 1 - Using policy document defined in data.tf
resource "aws_iam_policy" "policy_document_example" {
  name = "${local.name_prefix}-document-policy"
  description = "Example policy using data source"
  policy = data.aws_iam_policy_document.ec2_s3_list_policy.json
}
  
resource "aws_iam_role_policy_attachment" "attach_example" {
  role       = aws_iam_role.role_example.name
  policy_arn = aws_iam_policy.policy_document_example.arn
}

resource "aws_iam_instance_profile" "instance_profile_example" {
  name = "${local.name_prefix}-instance-profile"
  role = aws_iam_role.role_example.name
}

# Option 2 - Using inline policy

# resource "aws_iam_role_policy" "inline-policy-example" {
#   name = "${local.name_prefix}-inline-policy"
#   role = aws_iam_role.role_example.name
#   policy = jsonencode({
#     version = "2012-10-17"
#     statement = [
#       {
#         effect = "Allow"
#         action = ["s3:ListBucket"]
#         resource = ["*"]
#       },
#       {
#         effect = "Allow"
#         action = ["ec2:DescribeInstances"]
#         resource = ["*"]
#       }
#     ]
#   })
# }

# Option 3 - Using the policy inline heredoc
# resource "aws_iam_role_policy" "inline-heredoc-policy-example" {
#   name = "${local.name_prefix}-inline-heredoc-policy"
#   role = aws_iam_role.role_example.name
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "s3:ListBucket",
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": "ec2:DescribeInstances",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
