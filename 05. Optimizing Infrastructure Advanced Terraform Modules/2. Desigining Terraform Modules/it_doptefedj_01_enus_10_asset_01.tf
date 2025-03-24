# modules/s3_bucket/main.tf

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the bucket"
  type        = list(object({
    id                                     = string
    prefix                                 = optional(string)
    enabled                                = bool
    expiration                             = optional(map(string))
    transition                             = optional(map(string))
  }))
  default = []
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags = {
    Name        = var.bucket_name
    Environment = "Managed by Terraform"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      prefix = rule.value.prefix
      status = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "expiration" {
        for_each = [rule.value.expiration]
        content {
          days = expiration.value["days"]
        }
      }

      dynamic "transition" {
        for_each = [rule.value.transition]
        content {
          days          = transition.value["days"]
          storage_class = transition.value["storage_class"]
        }
      }
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}


# ---
# modules/s3_bucket/outputs.tf

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}


# ---
# dev/main.tf

provider "aws" {
  region = "us-west-2"
}

module "dev_s3_bucket" {
  source            = "../modules/s3_bucket"
  bucket_name       = "dev-app-logs"
  enable_versioning = true
  lifecycle_rules = [
    {
      id      = "expire-logs"
      enabled = true
      expiration = {
        days = 30
      }
    },
    {
      id      = "transition-logs"
      enabled = true
      transition = {
        days          = 90
        storage_class = "GLACIER"
      }
    }
  ]
}

output "dev_bucket_name" {
  value = module.dev_s3_bucket.bucket_name
}

