provider "aws" {
  region = "us-east-1"
}

# AWS EC2 Instance for GPU-Accelerated Training
resource "aws_instance" "gpu_training_instance" {
  ami           = "ami-12345678"
  instance_type = "p3.2xlarge"
  key_name      = "my-ec2-keypair"

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  tags = {
    Name = "GPU Training Instance"
  }
}

# AWS S3 Bucket for Data Storage
resource "aws_s3_bucket" "data_storage" {
  bucket = "ai-infrastructure-data"
  acl    = "private"
}

# AWS CloudWatch Alarm for Instance Monitoring
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name                = "HighCPUUtilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarm when CPU exceeds 80% utilization"
  dimensions = {
    InstanceId = aws_instance.gpu_training_instance.id
  }
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_role" {
  name               = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# IAM Policy Document for Lambda Role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

