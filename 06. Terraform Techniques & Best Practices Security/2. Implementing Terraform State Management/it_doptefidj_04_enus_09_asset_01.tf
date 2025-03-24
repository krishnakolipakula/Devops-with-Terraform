# Configure the provider
provider "aws" {
  region = "us-west-2"
}

# Define an S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
  acl    = "private"
}

# Enable versioning on the S3 bucket to preserve the history of Terraform state files
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a DynamoDB table for state locking to prevent concurrent runs of Terraform
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Configure the backend to use S3 for state storage and DynamoDB for locking
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/my/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
    acl            = "private"
  }
}

