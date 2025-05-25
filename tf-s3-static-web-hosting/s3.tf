resource "aws_s3_bucket" "static_bucket" {
  bucket = "${var.name}.sctp-sandbox.com"
  force_destroy = true
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_bucket.id
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_read_access" {
  bucket = aws_s3_bucket.static_bucket.id
  policy = data.aws_iam_policy_document.allow_read_access.json
  depends_on = [aws_s3_bucket_public_access_block.public_access]
}
  

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_bucket.id

  index_document {
    suffix = "index.html"
  }
  }

resource aws_route53_record "www" {
  zone_id = data.aws_route53_zone.sctp-sandbox.zone_id
  name    = aws_s3_bucket.static_bucket.bucket
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.website.website_domain
    zone_id                = aws_s3_bucket.static_bucket.hosted_zone_id
    evaluate_target_health = true
  }
}

# This resource will execute the upload script after the S3 bucket is created
resource "null_resource" "upload_to_s3" {
  depends_on = [
    aws_s3_bucket.static_bucket,
    aws_s3_bucket_policy.allow_read_access,
    aws_s3_bucket_website_configuration.website
  ]

  provisioner "local-exec" {
    command = "chmod +x ${path.module}/upload_to_s3.sh && ${path.module}/upload_to_s3.sh"
  }

  # This ensures the script runs on every apply
  triggers = {
    always_run = "${timestamp()}"
  }
}
