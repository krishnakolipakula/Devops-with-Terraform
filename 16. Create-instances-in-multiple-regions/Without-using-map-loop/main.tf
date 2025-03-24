# main.tf - Main configuration for the multi-region EC2 deployment

# Configure AWS providers for multiple regions
provider "aws" {
  alias  = "east1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "west2"
  region = "us-west-2"
}

# EC2 Instances in us-east-1
resource "aws_instance" "east1_instances" {
  provider      = aws.east1
  count         = var.east1_instance_count
  ami           = var.ami_east1
  instance_type = var.instance_type

  tags = {
    Name   = "east1-instance-${count.index + 1}"
    Region = "us-east-1"
  }
}

# EC2 Instances in us-west-1
resource "aws_instance" "west1_instances" {
  provider      = aws.west1
  count         = var.west1_instance_count
  ami           = var.ami_west1
  instance_type = var.instance_type

  tags = {
    Name   = "west1-instance-${count.index + 1}"
    Region = "us-west-1"
  }
}

# EC2 Instances in us-west-2
resource "aws_instance" "west2_instances" {
  provider      = aws.west2
  count         = var.west2_instance_count
  ami           = var.ami_west2
  instance_type = var.instance_type

  tags = {
    Name   = "west2-instance-${count.index + 1}"
    Region = "us-west-2"
  }
}