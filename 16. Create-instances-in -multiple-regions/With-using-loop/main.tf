# main.tf - Main configuration for the multi-region EC2 deployment

# Configure AWS providers dynamically for multiple regions
provider "aws" {
  region = "us-east-1" # Default provider
}

# Create providers for each region
locals {
  # Create a list of all region names
  region_names = keys(var.regions)
  
  # Create a flattened list of all instances to create
  instance_configs = flatten([
    for region, config in var.regions : [
      for i in range(config.count) : {
        region = region
        index  = i
        ami    = config.ami
      }
    ]
  ])
}

# Create provider aliases for each region
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

# Create instances across regions
resource "aws_instance" "instances" {
  # Loop through all instances to create
  for_each = {
    for idx, config in local.instance_configs : 
      "${config.region}-${config.index}" => config
  }
  
  # Use provider alias based on region
  provider = aws.${replace(each.value.region, "-", "_")}
  
  ami           = each.value.ami
  instance_type = var.instance_type
  
  tags = merge(
    var.common_tags,
    {
      Name   = "${each.value.region}-instance-${each.value.index + 1}"
      Region = each.value.region
    }
  )
}
