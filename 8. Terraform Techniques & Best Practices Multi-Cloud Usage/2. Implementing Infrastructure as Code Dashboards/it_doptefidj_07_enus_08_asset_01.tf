provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with an appropriate AMI ID
  instance_type = "t3.micro"
  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_cloudwatch_dashboard" "example_dashboard" {
  dashboard_name = "iac-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "${aws_instance.example.id}" ]
          ],
          view = "timeSeries",
          stacked = false,
          region = "us-west-2",
          title = "EC2 CPU Utilization"
        }
      },
      {
        type = "metric",
        x = 0,
        y = 6,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/S3", "BucketSizeBytes", "BucketName", "example-bucket" ]
          ],
          view = "timeSeries",
          stacked = false,
          region = "us-west-2",
          title = "S3 Bucket Size"
        }
      }
    ]
  })
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
}

