# Configure the AWS provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = "true"
    }
  }
}

# VPC Module from the Terraform Registry
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
  cidr = var.vpc_cidr

  # slice(list, startindex, endindex)
  azs = slice(tolist(data.aws_availability_zones.available.names), 0, min(3, length(data.aws_availability_zones.available.names)))

  # cidrsubnet(base_cidr, new_bits, subnet_index)
  private_subnets = [cidrsubnet(var.vpc_cidr, 8, 0), cidrsubnet(var.vpc_cidr, 8, 1)]
  public_subnets  = [cidrsubnet(var.vpc_cidr, 8, 100), cidrsubnet(var.vpc_cidr, 8, 101)]
  enable_nat_gateway = true

  tags = {
    Name        = var.vpc_name
  }

  # Apply a general name for all public subnets
  public_subnet_tags = {
    Name        = "public-subnet"
  }

  # Apply a general name for all private subnets
  private_subnet_tags = {
    Name        = "private-subnet"
  }
}

# EC2 Instance Module from the Terraform Registry
module "ec2-instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"

  count = 1
  name  = "web_server-1"

  ami                    = var.ami_us-east-1_linux2023
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
  }
}

# retrieve the list of availability zones
data "aws_availability_zones" "available" {}