provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "gpu_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Deep Learning Base AMI
  instance_type = "p3.2xlarge"           # GPU-enabled instance
  key_name      = "ml-training-key"
  subnet_id     = var.subnet_id

  tags = {
    Name = "ML-GPU-Instance"
  }

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }
}

resource "aws_s3_bucket" "ml_data_bucket" {
  bucket_prefix = "ml-training-data-"
  acl           = "private"

  tags = {
    Environment = "AI/ML"
    Project     = "Deep Learning Experiment"
  }
}

variables.tf
variable "subnet_id" {
  description = "The subnet ID where the GPU instance will be launched"
  type        = string
}

