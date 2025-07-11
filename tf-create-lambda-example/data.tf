data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/lambda/function.py"
  output_path = "${path.module}/lambda/function.zip"
}