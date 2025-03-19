provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  tags = {
    Name        = "example-bucket"
    Environment = "Development"
  }
}

output "bucket_arn" {
  value = aws_s3_bucket.example.arn
}

# *** New Configuration
# *** This configuration will take over management of the S3 bucket.

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  tags = {
    Name        = "example-bucket"
    Environment = "Development"
  }
}

output "bucket_arn" {
  value = aws_s3_bucket.example.arn
}

