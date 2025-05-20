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
      "ec2:RebootInstances",
      "ec2:CreateSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:CreateKeyPair"
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