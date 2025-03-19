resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  acl    = var.bucket_acl

  tags = {
    Environment = var.environment
  }
}

