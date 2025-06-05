resource "aws_s3_bucket" "lambda_trigger_bucket" {
  bucket = "${var.function_name}-lambda-trigger-bucket" 
  force_destroy = true

  tags = {
    Name        = "Lambda Trigger Bucket"
    Environment = "Development"
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.function_name}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
} 

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.function_name}-lambda-policy"
  role = aws_iam_role.lambda_exec_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}


 # This resource was intentionally created to ensure that terraform destroy destroys this log group 
 # If this resource was not added explicitly aws will still automatically create a log group for the lambda function
 # but since it was not explicitly created terraform destroy will not destroy the log group and may retain for the retention period
 #period specified in the resource.

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}-lambda-function"
  retention_in_days = 14
  
  tags = {
    Name        = "${var.function_name} Lambda Log Group"
    Environment = "Development"
  }
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.function_name}-lambda-function"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "function.lambda_handler"
  runtime          = "python3.13"
  role             = aws_iam_role.lambda_exec_role.arn
  
  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group
  ]
}



# Lambda permission for S3 to invoke the function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda_trigger_bucket.arn
}

# S3 bucket notification configuration
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.lambda_trigger_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
    filter_suffix       = ".jpg"
  }
}