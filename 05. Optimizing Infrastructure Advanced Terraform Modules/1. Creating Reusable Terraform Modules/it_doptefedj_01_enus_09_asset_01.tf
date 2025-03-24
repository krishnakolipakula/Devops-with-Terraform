# modules/ec2_instance/main.tf

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "security_group_rules" {
  description = "List of security group rules"
  type        = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

resource "aws_security_group" "instance_sg" {
  name = "${var.instance_name}-sg"

  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }

  security_groups = [aws_security_group.instance_sg.name]
}

output "instance_id" {
  value = aws_instance.example.id
}

# ---
# modules/ec2_instance/outputs.tf

output "security_group_id" {
  value = aws_security_group.instance_sg.id
}

# ---
# dev/main.tf

provider "aws" {
  region = "us-west-2"
}

module "dev_instance" {
  source           = "../modules/ec2_instance"
  instance_name    = "dev-ec2"
  instance_type    = "t3.medium"
  ami_id           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID
  security_group_rules = [
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

output "dev_instance_id" {
  value = module.dev_instance.instance_id
}

