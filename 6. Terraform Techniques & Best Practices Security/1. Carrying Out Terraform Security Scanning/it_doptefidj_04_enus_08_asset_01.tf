provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example Security Group"
  
  // Allow SSH only from specific IP range
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }

  // Allow HTTP from any IP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Deny all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }
}

resource "aws_config_configuration_recorder" "example" {
  name     = "example-recorder"
  role_arn = "arn:aws:iam::123456789012:role/AWSConfigRole"
}

resource "aws_config_config_rule" "example" {
  name        = "example-rule"
  source {
    owner             = "AWS"
    source_identifier = "SECURITY_GROUP_RULES_CHECK"
  }
}

resource "aws_config_aggregation_authorization" "example" {
  authorized_account_id = "123456789012"
  region                = "us-west-2"
}

resource "aws_securityhub_account" "example" {}

resource "aws_securityhub_member" "example" {
  account_id = "123456789012"
  email      = "example@example.com"
  invite     = true
}

