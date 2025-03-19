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

resource "aws_cloudwatch_log_group" "example_log_group" {
  name = "example-log-group"
}

resource "aws_cloudwatch_log_stream" "example_log_stream" {
  name           = "example-log-stream"
  log_group_name = aws_cloudwatch_log_group.example_log_group.name
}

resource "aws_xray_sampling_rule" "example_rule" {
  name        = "example-sampling-rule"
  priority    = 1
  fixed_rate  = 0.05
  reservoir_size = 10
  service_name = "example-service"
  resource_arn = "arn:aws:ec2:us-west-2:123456789012:instance/${aws_instance.example.id}"
  host         = "example-host"
  http_method  = "GET"
  url_path     = "/api/v1/example"
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

