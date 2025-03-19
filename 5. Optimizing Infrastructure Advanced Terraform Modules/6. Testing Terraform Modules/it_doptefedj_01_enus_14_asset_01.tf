# modules/ec2_instance/main.tf

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}

# ---
# modules/ec2_instance/variables.tf

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

# ---
# modules/ec2_instance/outputs.tf

output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.example.id
}


# --- 
# test/main.tf

module "ec2_instance" {
  source        = "../modules/ec2_instance"
  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  instance_name = "test-instance"
}


