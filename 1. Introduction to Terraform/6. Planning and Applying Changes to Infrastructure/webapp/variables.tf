variable "ami_us-east-1_linux2" {
  description = "the Amazon Linux 2 AMI in us-east-1"
  type        = string
  default     = "ami-0e54eba7c51c234f6"
}
variable "ami_us-east-1_linux2023" {
  description = "the Amazon Linux 2023 AMI in us-east-1"
  type        = string
  default     = "ami-0ebfd941bbafe70c6"
}
variable "ami_us-west-1_linux2023" {
  description = "the Amazon Linux 2023 AMI in us-west-1"
  type        = string
  default     = "ami-047d7c33f6e7b4bc4"
}
variable "aws_region" {
  description = "the AWS region value"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "the environment currently being worked in"
  type        = string
  default     = "development"
}