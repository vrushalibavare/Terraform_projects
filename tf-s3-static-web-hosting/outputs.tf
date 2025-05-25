output "website_endpoint" {
  description = "The website endpoint URL"
  value       = "http://${aws_s3_bucket.static_bucket.bucket}"
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.static_bucket.bucket
}