module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "${var.db_name}-dynamodb"
  hash_key = "year"

  attributes = [
    {
      name = "year"
      type = "N"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
    Name =  "${var.db_name}-dynamodb"
  }
}

resource aws_iam_role "lambda_execution_role" {
  name = "${var.db_name}-lambda-role"

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


resource "aws_iam_role_policy" "lambda_dynamodb_access_policy" {
  name   = "${var.db_name}-lambda-dynamodb-access-policy"
  role   = aws_iam_role.lambda_execution_role.name
  policy = data.aws_iam_policy_document.lambda_dynamodb_access_policy.json
}

# Attach AWS managed policies to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.db_name}-httpapi-lambda-function"
  description   = "Lambda function for HTTP API integration with DynamoDB"
  handler       = "function.lambda_handler"
  runtime       = "python3.13"
  source_path = "${path.module}/package"
  create_role = false
  lambda_role = aws_iam_role.lambda_execution_role.arn
  environment_variables = {
    "DDB_TABLE" = module.dynamodb_table.dynamodb_table_id
  }
  cloudwatch_logs_retention_in_days = 7 
  tags = {
    Name = "${var.db_name}-httpapi-lambda-function"
  }
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.db_name}-http-lambda-ddb-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = module.lambda_function.lambda_function_invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"

}

resource "aws_apigatewayv2_route" "get_all" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /topmovies"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "get_one" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /topmovies/{year}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "put" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "PUT /topmovies"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "delete" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "DELETE /topmovies/{year}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_log_group.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      integrationLatency = "$context.integrationLatency"
    })
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/api-gateway/${aws_apigatewayv2_api.http_api.name}"
  retention_in_days = 7
}


