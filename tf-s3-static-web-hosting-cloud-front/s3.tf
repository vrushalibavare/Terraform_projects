resource "aws_s3_bucket" "static_bucket" {
  bucket = "${var.name}.sctp-sandbox.com"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "private_access" {
  bucket = aws_s3_bucket.static_bucket.id

  block_public_acls       = true  
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy to allow access from CloudFront OAC
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_bucket.id
  #depends_on = [aws_cloudfront_distribution.static_distribution]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.static_bucket.arn}/*"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.static_distribution.arn
          }
        }
      }
    ]
  })
}


# This resource will execute the upload script after the S3 bucket is created
resource "null_resource" "upload_to_s3" {
  depends_on = [
    aws_s3_bucket.static_bucket,
    aws_s3_bucket_public_access_block.private_access
  ]

  provisioner "local-exec" {
    command = "chmod +x ${path.module}/upload_to_s3.sh && ${path.module}/upload_to_s3.sh"
  }

  # This ensures the script runs on every apply
  triggers = {
    always_run = "${timestamp()}"
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "acm" {
  source = "terraform-aws-modules/acm/aws"

  providers = {
    aws = aws.us-east-1
  }

  domain_name = "${var.name}.sctp-sandbox.com"
  zone_id     = "Z00541411T1NGPV97B5C0"

  wait_for_validation = true
  create_route53_records = true
  key_algorithm = "RSA_2048"
  validation_method = "DNS"

  tags = {
    Name = "${var.name}.sctp-sandbox.com"
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.name}-oac"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Data source for the CloudFront caching optimized policy
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}


resource aws_cloudfront_distribution static_distribution {
  origin {
    domain_name = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_id   = "static_bucket"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [ "${var.name}.sctp-sandbox.com" ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "static_bucket"
    
    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
    
    viewer_protocol_policy = "redirect-to-https"
    compress               = false
  }

  
  price_class = "PriceClass_All"
  web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn

  viewer_certificate {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# Route 53 A record pointing to CloudFront distribution
resource "aws_route53_record" "website" {
  zone_id = "Z00541411T1NGPV97B5C0"  # Same zone ID used in ACM module
  name    = "${var.name}.sctp-sandbox.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.static_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
