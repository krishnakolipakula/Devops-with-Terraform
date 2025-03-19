provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/application/logs"
  retention_in_days = 30

  tags = {
    Environment = "Production"
    Application = "WebApp"
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "app-log-stream"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}

resource "aws_iam_role" "log_writer_role" {
  name = "log-writer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "log_writer_policy" {
  name = "log-writer-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "log_writer_policy_attachment" {
  role       = aws_iam_role.log_writer_role.name
  policy_arn = aws_iam_policy.log_writer_policy.arn
}

