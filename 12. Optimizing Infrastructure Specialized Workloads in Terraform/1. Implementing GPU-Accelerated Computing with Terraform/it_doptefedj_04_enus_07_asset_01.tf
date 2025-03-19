provider "aws" {
  region = "us-west-2"
}

# GPU-Enabled EC2 Instance
resource "aws_instance" "gpu_instance" {
  ami           = "ami-12345678" # Replace with the GPU AMI ID for your region
  instance_type = "p3.2xlarge"   # GPU instance type
  key_name      = "my-key-pair"

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  tags = {
    Name = "GPU-Accelerated Instance"
  }
}

# S3 Bucket for Data Storage
resource "aws_s3_bucket" "data_bucket" {
  bucket = "gpu-computing-dataset-storage"
  acl    = "private"
}

# CloudWatch Monitoring
resource "aws_cloudwatch_metric_alarm" "gpu_utilization_alarm" {
  alarm_name                = "HighGPUUtilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "GPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 85
  alarm_description         = "Alert when GPU utilization exceeds 85%"
  dimensions = {
    InstanceId = aws_instance.gpu_instance.id
  }
}

# IAM Role for Access
resource "aws_iam_role" "gpu_role" {
  name               = "gpu-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.gpu_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

