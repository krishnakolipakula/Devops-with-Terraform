provider "aws" {
  region = "us-west-2"
}

# Create a custom IAM policy for EC2 management
resource "aws_iam_policy" "ec2_management_policy" {
  name        = "EC2ManagementPolicy"
  description = "Policy for managing EC2 instances"

  # Define policy using JSON
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ec2:DescribeInstances"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Create a custom IAM policy for S3 bucket management
resource "aws_iam_policy" "s3_management_policy" {
  name        = "S3ManagementPolicy"
  description = "Policy for managing S3 buckets and objects"

  # Define policy using JSON
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::my-bucket-name",
          "arn:aws:s3:::my-bucket-name/*"
        ]
      }
    ]
  })
}

# Create an IAM role and attach the EC2 policy
resource "aws_iam_role" "ec2_role" {
  name               = "EC2Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach EC2 policy to the EC2 role
resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  policy_arn = aws_iam_policy.ec2_management_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# Create an IAM role and attach the S3 policy
resource "aws_iam_role" "s3_role" {
  name               = "S3Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

# Attach S3 policy to the S3 role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  policy_arn = aws_iam_policy.s3_management_policy.arn
  role       = aws_iam_role.s3_role.name
}

