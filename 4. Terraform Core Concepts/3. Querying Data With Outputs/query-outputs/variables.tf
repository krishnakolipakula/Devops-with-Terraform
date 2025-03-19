variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name tag value for the EC2 instance"
  type        = string
  default     = "AppServer"
}
