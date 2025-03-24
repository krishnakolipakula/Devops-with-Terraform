# variables.tf - Variables for the multi-region EC2 deployment

variable "ami_east1" {
  description = "AMI ID for us-east-1 region"
  default     = "ami-08b5b3a93ed654d19" # Amazon Linux 2 AMI in us-east-1 (update with current AMI)
}

variable "ami_west1" {
  description = "AMI ID for us-west-1 region"
  default     = "ami-01eb4eefd88522422" # Amazon Linux 2 AMI in us-west-1 (update with current AMI)
}

variable "ami_west2" {
  description = "AMI ID for us-west-2 region"
  default     = "ami-0b6d6dacf350ebc82" # Amazon Linux 2 AMI in us-west-2 (update with current AMI)
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t2.micro"
}

variable "east1_instance_count" {
  description = "Number of instances to create in us-east-1"
  default     = 2
}

variable "west1_instance_count" {
  description = "Number of instances to create in us-west-1"
  default     = 2
}

variable "west2_instance_count" {
  description = "Number of instances to create in us-west-2"
  default     = 1
}