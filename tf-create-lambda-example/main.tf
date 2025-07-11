

resource "aws_lambda_function" "lambda_function_example" {
  function_name    = "${var.function_name}-function"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "function.lambda_handler" # Adjust the handler based on your Lambda function code.
  runtime          = "python3.13"
  role             = aws_iam_role.lambda_exec_role.arn
  # Environment variables for the Lambda function. Add any necessary variables here.Check your Lambda function code for required environment variables.
  #environment {
   # variables = {}


  tracing_config {
    mode = "Active" # Enable X-Ray tracing for the Lambda function
  }
}


resource aws_iam_role "lambda_exec_role" {
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

resource aws_iam_role_policy_attachment "lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Add policies for additional permissions if needed in data.tf as policy documents.

