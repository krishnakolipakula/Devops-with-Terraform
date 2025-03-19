provider "aws" {
  region = "us-east-1"
}

# Define a VPC
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "TestVPC"
  }
}

# Define a Subnet
resource "aws_subnet" "test_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "TestSubnet"
  }
}

# Define a Security Group
resource "aws_security_group" "test_sg" {
  vpc_id = aws_vpc.test_vpc.id
  name   = "TestSecurityGroup"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TestSecurityGroup"
  }
}

