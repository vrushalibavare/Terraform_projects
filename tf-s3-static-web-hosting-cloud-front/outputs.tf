output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.static_bucket.id
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.static_bucket.bucket_regional_domain_name
}