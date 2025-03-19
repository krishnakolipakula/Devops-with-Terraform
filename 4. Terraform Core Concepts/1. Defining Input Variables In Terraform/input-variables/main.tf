provider "aws" {
  region = "us-east-1" # the hard-coded region where resources will be deployed
}

resource "aws_instance" "app_server" {
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"

  tags = {
    Name = "AppServer" # the hard-coded Name tag for the ec2 instance
  }
}