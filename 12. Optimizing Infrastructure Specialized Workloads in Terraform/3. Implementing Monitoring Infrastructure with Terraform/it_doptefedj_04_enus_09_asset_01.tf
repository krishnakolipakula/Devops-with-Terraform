provider "aws" {
  region = "us-east-1"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/app/logs"
  retention_in_days = 30
}

# CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
}

# SNS Topic for Alarm Notifications
resource "aws_sns_topic" "alarm_notifications" {
  name = "alarm-notifications"
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "alerts@example.com"
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "monitoring_dashboard" {
  dashboard_name = "AppMonitoringDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type  = "metric",
        x     = 0,
        y     = 0,
        width = 24,
        height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.web_server.id],
            ["AWS/EC2", "NetworkIn", "InstanceId", aws_instance.web_server.id],
            ["AWS/EC2", "NetworkOut", "InstanceId", aws_instance.web_server.id]
          ]
          view   = "timeSeries"
          stacked = false
          region = "us-east-1"
        }
      }
    ]
  })
}

# Example EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 AMI
  instance_type = "t2.micro"
  tags = {
    Name = "WebServer"
  }
}

