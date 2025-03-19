resource "aws_instance" "web_server" {
  ami           = "ami-0c9483720cff7227e" # Replace with your desired AMI
  instance_type = "t2.micro"
  # ... other configuration ...
}
