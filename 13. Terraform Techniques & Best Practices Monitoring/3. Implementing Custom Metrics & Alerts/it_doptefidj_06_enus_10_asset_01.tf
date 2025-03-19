provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_metric_alarm" "high_response_time_alarm" {
  alarm_name          = "HighResponseTime"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 500
  period              = 60
  statistic           = "Average"
  metric_name         = "ResponseTime"
  namespace           = "Custom/Application"
  alarm_description   = "Triggered when average response time exceeds 500ms."
  alarm_actions       = ["arn:aws:sns:us-west-2:123456789012:alert-topic"]
  ok_actions          = ["arn:aws:sns:us-west-2:123456789012:alert-topic"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_dashboard" "app_dashboard" {
  dashboard_name = "ApplicationMetricsDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["Custom/Application", "ResponseTime"]
          ]
          period     = 60
          stat       = "Average"
          title      = "Average Response Time"
        }
      }
    ]
  })
}

resource "aws_iam_role" "custom_metric_role" {
  name = "custom-metric-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "custom_metric_policy" {
  name = "custom-metric-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "custom_metric_policy_attachment" {
  role       = aws_iam_role.custom_metric_role.name
  policy_arn = aws_iam_policy.custom_metric_policy.arn
}

