resource "aws_sns_topic" "alarm_notification" {
  name = "${var.db_name}-info-metric-alarm-notification"
  
  tags = {
    Name        = "${var.db_name}-info-metric-alarm-notification"
    Environment = "staging"
    Terraform   = "true"
  }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notification.arn
  protocol  = "email"
  endpoint  = "vrushali.bavare@gmail.com"
}

resource "aws_cloudwatch_log_metric_filter" "info_count" {
  name           = "info-count"
  log_group_name = "/aws/lambda/${module.lambda_function.lambda_function_name}"
  pattern        = "INFO"

  metric_transformation {
    name      = "info-count"
    namespace = "/tf-moviesdb/vrush"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "info_metric_alarm" {
  alarm_name          = "${var.db_name}-info-count-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "info-count"
  namespace           = "/tf-moviesdb/vrush"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Alarm when INFO log count exceeds 10"
  
  alarm_actions = [
    aws_sns_topic.alarm_notification.arn
  ]
  
  tags = {
    Name        = "${var.db_name}-info-metric-alarm"
    Environment = "staging"
    Terraform   = "true"
  }
}