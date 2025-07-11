data aws_iam_policy_document lambda_ddb_policy {
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem"
    ]
    resources = ["*"]
}
}