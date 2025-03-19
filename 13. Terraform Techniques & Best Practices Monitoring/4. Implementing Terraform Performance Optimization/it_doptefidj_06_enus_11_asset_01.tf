provider "aws" {
  region = "us-west-2"
}

resource "aws_launch_configuration" "app_launch_config" {
  name = "app-launch-config"
  image_id = "ami-0c55b159cbfafe1f0"  # Replace with an appropriate AMI ID
  instance_type = "t3.medium"
  security_groups = ["sg-12345678"]
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
  EOF
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 10
  min_size             = 2
  vpc_zone_identifier  = ["subnet-12345678", "subnet-23456789"]
  launch_configuration = aws_launch_configuration.app_launch_config.id
  health_check_type    = "EC2"
  health_check_grace_period = 300
  availability_zones   = ["us-west-2a", "us-west-2b"]
  force_delete         = true
}

resource "aws_application_load_balancer" "app_alb" {
  name               = "app-load-balancer"
  internal           = false
  security_groups    = ["sg-12345678"]
  subnets            = ["subnet-12345678", "subnet-23456789"]
  load_balancer_type = "application"
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_application_load_balancer.app_alb.arn
  port              = 80
  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      message_body = "OK"
    }
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

