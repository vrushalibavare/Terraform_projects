data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
    effect = "Allow"
  }
  
  statement {
    actions = [
      "s3:PutObject",
      "s3:PostObject",
      "s3:CopyObject",
      "s3:CompleteMultipartUpload"
    ]
    resources = ["${aws_s3_bucket.lambda_trigger_bucket.arn}/*"]
    effect = "Allow"
  }

  depends_on = [
    aws_s3_bucket.lambda_trigger_bucket,
    aws_lambda_function.lambda_function
  ]
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/lambda/function.py"
  output_path = "${path.module}/lambda/function.zip"
}


