provider "aws" {
  region = "us-west-2"
}

# Define VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MultiTierVPC"
  }
}

# Define Subnets for Each Tier
resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "WebSubnet"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "AppSubnet"
  }
}

resource "aws_subnet" "db_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "DBSubnet"
  }
}

# Define Security Groups for Each Tier
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow traffic from web tier"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AppSecurityGroup"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow traffic from app tier"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DBSecurityGroup"
  }
}

# EC2 Instances for Each Tier
resource "aws_instance" "web_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example Amazon Linux AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.web_subnet.id
  security_groups = [aws_security_group.web_sg.name]
  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "app_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.app_sg.name]
  tags = {
    Name = "AppServer"
  }
}

resource "aws_instance" "db_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.db_subnet.id
  security_groups = [aws_security_group.db_sg.name]
  tags = {
    Name = "DBServer"
  }
}

