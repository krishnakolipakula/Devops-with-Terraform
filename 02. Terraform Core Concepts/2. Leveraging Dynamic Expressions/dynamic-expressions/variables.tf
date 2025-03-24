variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "primary_vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "development"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_us-east-1_linux2023" {
  description = "The Amazon Linux 2023 AMI in us-east-1"
  type        = string
  default     = "ami-0ebfd941bbafe70c6"
}
