provider "aws" {
  region = "us-east-1"
}

# Launch Template for AI Instances
resource "aws_launch_template" "ai_template" {
  name          = "ai-instance-template"
  instance_type = "g4dn.xlarge" # GPU instance for AI workloads
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 with AI tools

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 100
      volume_type = "gp3"
    }
  }

  tags = {
    Name = "AIInstance"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ai_asg" {
  launch_template {
    id      = aws_launch_template.ai_template.id
    version = "$Latest"
  }

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.app_subnet.id]

  tag {
    key                 = "Name"
    value               = "AIASG"
    propagate_at_launch = true
  }
}

# Application Load Balancer
resource "aws_lb" "ai_lb" {
  name               = "ai-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.app_subnet.id]
}

# Target Group
resource "aws_lb_target_group" "ai_tg" {
  name     = "ai-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Listener for Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ai_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ai_tg.arn
  }
}

# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb-security-group"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VPC and Subnet
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

