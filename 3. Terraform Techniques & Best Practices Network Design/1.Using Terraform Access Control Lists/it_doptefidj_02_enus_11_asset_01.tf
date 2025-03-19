provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-unique-example-bucket-name"

  acl = "private" # Options include "private", "public-read", "public-read-write", etc.

  tags = {
    Name        = "ExampleBucket"
    Environment = "Demo"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.example_bucket.id
  acl    = "public-read"
}

