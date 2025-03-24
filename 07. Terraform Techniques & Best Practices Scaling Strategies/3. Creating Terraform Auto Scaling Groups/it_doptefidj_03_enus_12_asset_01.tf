provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "AutoScalingVPC"
  }
}

# Create a subnet for the Auto Scaling group
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "AutoScalingSubnet"
  }
}

# Create a Security Group for the instances
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "InstanceSecurityGroup"
  }
}

# Create a Launch Template
resource "aws_launch_template" "example" {
  name = "example-launch-template"
  
  instance_type = "t2.micro"
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI example
  
  security_group_names = [aws_security_group.instance_sg.name]
  key_name            = "my-ssh-key"  # Replace with your key pair name
  
  user_data = <<-EOT
              #!/bin/bash
              echo "Hello World" > /var/www/html/index.html
              sudo service httpd start
              EOT
}

# Create an Application Load Balancer (ALB)
resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.instance_sg.id]
  subnets            = [aws_subnet.main.id]
  
  enable_deletion_protection = false

  tags = {
    Name = "example-alb"
  }
}

# Create an Autoscaling Group
resource "aws_autoscaling_group" "example" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.main.id]
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  
  health_check_type          = "EC2"
  health_check_grace_period = 300
  load_balancers            = [aws_lb.example.id]
  
  tags = [
    {
      key                 = "Name"
      value               = "AutoScalingInstance"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}

