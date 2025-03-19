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
  ok_actions          = ["arn:aws:sns:us-west-2:123456789012:alert-topic"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_dashboard" "example_dashboard" {
  dashboard_name = "example-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "${aws_instance.example.id}" ]
          ],
          view = "timeSeries",
          stacked = false,
          region = "us-west-2",
          title = "EC2 CPU Utilization"
        }
      }
    ]
  })
}

