# EC2 policy document for creating, viewing, and deleting instances
data "aws_iam_policy_document" "ec2_s3_list_policy" {
  statement {
    actions = [
      "ec2:Describe*"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
    ]
    resources = ["*"]
  }
}
  