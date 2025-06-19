data "aws_iam_policy_document" "lambda_dynamodb_access_policy" {
  # DynamoDB permissions
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan"
    ]
    resources = [module.dynamodb_table.dynamodb_table_arn]
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/package/function.py"
  output_path = "${path.module}/package/function.zip"
}

  
  
