# variables.tf - Variables for the multi-region EC2 deployment

variable "regions" {
  description = "Map of regions with instance counts and AMIs"
  type = map(object({
    count = number
    ami   = string
  }))
  default = {
    "us-east-1" = {
      count = 2
      ami   = "ami-0c55b159cbfafe1f0" # Update with current AMI
    },
    "us-west-1" = {
      count = 2
      ami   = "ami-0e4d9ed95865f3b40" # Update with current AMI
    },
    "us-west-2" = {
      count = 1
      ami   = "ami-0cea098ed2ac54925" # Update with current AMI
    }
  }
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t2.micro"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {
    Project = "Multi-Region-Deployment"
    ManagedBy = "Terraform"
  }
}
