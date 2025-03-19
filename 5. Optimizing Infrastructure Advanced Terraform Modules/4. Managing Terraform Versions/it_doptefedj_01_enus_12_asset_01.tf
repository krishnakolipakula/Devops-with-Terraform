terraform {
  required_version = ">= 1.1.0, < 2.0.0"
}

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

