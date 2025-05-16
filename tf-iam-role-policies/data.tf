# EC2 policy document for creating, viewing, and deleting instances
data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:CreateTags",
      "ec2:Describe*",
      "ec2:TerminateInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances"
    ]
    resources = ["*"]
  }     
}

# S3 policy document for creating and viewing buckets
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:CreateBucket",
      "s3:PutBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetBucketTagging"
    ]
    resources = ["*"]
  } 
}    

 # RDS policy document for creating and viewing RDS instances 
data "aws_iam_policy_document" "rds_policy" {
  statement {
    actions = [
      "rds:Describe*",
      "rds:ListTagsForResource",
    ]
    resources = ["*"]
  }     
}

# Policy document for listing all S3 buckets and describing all EC2 instances
data "aws_iam_policy_document" "policy_document_example" {
  # Statement to allow listing all S3 buckets
  statement {
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = ["*"]
  }
  # Statement to allow describing all EC2 instances
  statement {
    effect = "Allow"
    actions = ["ec2:DescribeInstances"] 
    resources = ["*"] 
  }
}
  