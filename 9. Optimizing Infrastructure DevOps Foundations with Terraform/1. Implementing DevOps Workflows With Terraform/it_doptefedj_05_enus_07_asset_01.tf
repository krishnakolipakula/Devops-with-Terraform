provider "aws" {
  region = "us-east-1"
}

# Define a staging environment
resource "aws_instance" "staging" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    Name = "StagingInstance"
    Environment = "Staging"
  }
}

# Define a production environment
resource "aws_instance" "production" {
  ami           = "ami-12345678"
  instance_type = "t2.medium"
  tags = {
    Name = "ProductionInstance"
    Environment = "Production"
  }
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id

  enable_deletion_protection = true
  tags = {
    Name = "AppLoadBalancer"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "lb-security-group"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

# Route53 Record for DNS
resource "aws_route53_record" "app_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.example.com"
  type    = "A"
  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}

