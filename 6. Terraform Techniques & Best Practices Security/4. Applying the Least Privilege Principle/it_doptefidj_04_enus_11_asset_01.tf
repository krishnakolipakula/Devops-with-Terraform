# Define the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Create an IAM policy that grants limited access to a specific S3 bucket
resource "aws_iam_policy" "limited_s3_access" {
  name        = "LimitedS3Access"
  description = "Allow access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::my-secure-bucket/*"
      }
    ]
  })
}

# Create an IAM user with the limited policy attached
resource "aws_iam_user" "limited_user" {
  name = "limited-user"
}

resource "aws_iam_user_policy_attachment" "limited_user_policy" {
  user       = aws_iam_user.limited_user.name
  policy_arn = aws_iam_policy.limited_s3_access.arn
}

# Create an IAM role for an EC2 instance with limited permissions
resource "aws_iam_role" "limited_ec2_role" {
  name               = "limited-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_policy" {
  role   = aws_iam_role.limited_ec2_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::my-secure-bucket/*"
      }
    ]
  })
}

# Create an EC2 instance with the limited IAM role attached
resource "aws_instance" "limited_ec2_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_role.limited_ec2_role.name
}

