resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name        = "${var.name}-cloudfront-waf"
  description = "WAF ACL for CloudFront distribution with managed rule sets"
  scope       = "CLOUDFRONT"
  
  provider    = aws.us-east-1  # CloudFront WAF must be created in us-east-1

  default_action {
    allow {}
  }

  # AWS IP Reputation List - blocks requests from IP addresses on reputation lists
  rule {
    name     = "AWSManagedIPReputationList"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedIPReputationList"
      sampled_requests_enabled   = true
    }
  }

  # Core Rule Set - blocks common web application vulnerabilities
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Known Bad Inputs - blocks patterns that are known to be invalid input
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-cloudfront-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.name}-cloudfront-waf"
  }
}

# Output the WAF ACL ID for reference
output "waf_web_acl_id" {
  description = "The ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.cloudfront_waf.id
}

output "waf_web_acl_arn" {
  description = "The ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.cloudfront_waf.arn
}