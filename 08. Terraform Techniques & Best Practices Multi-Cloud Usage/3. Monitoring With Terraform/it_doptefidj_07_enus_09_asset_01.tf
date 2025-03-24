provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with an appropriate AMI ID
  instance_type = "t3.micro"
  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 80
  period              = 300
  statistic           = "Average"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  alarm_description   = "Triggered when CPU utilization exceeds 80%."
  alarm_actions       = ["arn:aws:sns:us-west-2:123456789012:alert-topic"]
}

resource "aws_cloudwatch_metric_alarm" "high_memory_alarm" {
  alarm_name          = "HighMemoryUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 75
  period              = 300
  statistic           = "Average"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  alarm_description   = "Triggered when memory utilization exceeds 75%."
  alarm_actions       = ["arn:aws:sns:us-west-2:123456789012:alert-topic"]
}

resource "aws_cloudwatch_metric_alarm" "high_disk_alarm" {
  alarm_name          = "HighDiskUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 90
  period              = 300
  statistic           = "Average"
  metric_name         = "DiskSpaceUtilization"
  namespace           = "System/Linux"
  alarm_description   = "Triggered when disk utilization exceeds 90%."
  alarm_actions       = ["arn:aws:sns:us-west-2:123456789012:alert-topic"]
}

