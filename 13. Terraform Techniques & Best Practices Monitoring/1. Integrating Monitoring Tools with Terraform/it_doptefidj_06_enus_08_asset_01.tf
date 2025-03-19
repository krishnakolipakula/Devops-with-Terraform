provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 80
  period              = 300
  statistic           = "Average"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  dimensions = {
    InstanceId = "i-0abcd1234efgh5678"
  }

  alarm_description = "This alarm triggers when CPU utilization exceeds 80%."
  alarm_actions     = ["arn:aws:sns:us-west-2:123456789012:notify-me"]
  ok_actions        = ["arn:aws:sns:us-west-2:123456789012:notify-me"]
  insufficient_data_actions = []

  tags = {
    Name = "HighCPUAlarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_network_in_alarm" {
  alarm_name          = "HighNetworkIn"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1000000
  period              = 300
  statistic           = "Sum"
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  dimensions = {
    InstanceId = "i-0abcd1234efgh5678"
  }

  alarm_description = "This alarm triggers when network traffic (in) exceeds 1MB."
  alarm_actions     = ["arn:aws:sns:us-west-2:123456789012:notify-me"]
  ok_actions        = ["arn:aws:sns:us-west-2:123456789012:notify-me"]
  insufficient_data_actions = []

  tags = {
    Name = "HighNetworkInAlarm"
  }
}

