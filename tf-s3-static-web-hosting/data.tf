data aws_route53_zone "sctp-sandbox" {
  name = "sctp-sandbox.com"
}

data aws_iam_policy_document "allow_read_access" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_bucket.arn}/*"]
  }
}
