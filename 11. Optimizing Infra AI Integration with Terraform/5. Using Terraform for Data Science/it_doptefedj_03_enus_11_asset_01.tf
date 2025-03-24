provider "aws" {
  region = "us-east-1"
}

# AWS S3 Bucket for Data Storage
resource "aws_s3_bucket" "data_bucket" {
  bucket = "data-science-workflow-bucket"
  acl    = "private"
}

# AWS EC2 Instance for Model Training
resource "aws_instance" "training_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.medium"
  key_name      = "my-ec2-keypair"

  tags = {
    Name = "Model Training Instance"
  }
}

# AWS Lambda Function for Data Processing
resource "aws_lambda_function" "data_processing" {
  filename         = "lambda.zip"
  function_name    = "data-processing-function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  timeout          = 120

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.data_bucket.bucket
    }
  }
}

# IAM Role for Lambda Permissions
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

