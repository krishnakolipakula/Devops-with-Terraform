resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic from specific CIDR block"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c9483720cff7227e" # Replace with your desired AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.id]
  tags = {
    Name        = "web-server-01"
    Environment = "production"
    Owner       = "john.doe@example.com"
  }
}
