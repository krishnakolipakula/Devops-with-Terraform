provider "aws" {
  region = "us-east-1"
}

# VPC with Private and Public Subnets
resource "aws_vpc" "secure_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "SecureVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.secure_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.secure_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

# Security Group
resource "aws_security_group" "secure_sg" {
  name        = "SecureAI"
  description = "Security group for AI infrastructure"
  vpc_id      = aws_vpc.secure_vpc.id

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

# S3 Bucket for Secure Storage
resource "aws_s3_bucket" "secure_data" {
  bucket        = "ai-secure-storage-${random_string.random_id.result}"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "SecureDataBucket"
  }
}

resource "random_string" "random_id" {
  length  = 8
  special = false
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "secure_s3_access" {
  name        = "SecureS3Access"
  description = "Policy for accessing secure S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject"],
        Effect   = "Allow",
        Resource = "${aws_s3_bucket.secure_data.arn}/*"
      }
    ]
  })
}

# CloudWatch Monitoring
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/ai-infrastructure"
  retention_in_days = 30
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_access" {
  alarm_name          = "UnauthorizedAccess"
  metric_name         = "UnauthorizedAccess"
  namespace           = "AWS/CloudTrail"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = []
}

