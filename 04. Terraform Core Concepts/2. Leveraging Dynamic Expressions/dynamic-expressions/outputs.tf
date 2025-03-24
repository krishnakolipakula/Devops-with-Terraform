# produces a single output, ie: the ID of the VPC
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC created by the vpc module"
}

# directly reference the attribute without a splat expression when the module returns a single list attribute
output "public_subnet_ids" {
  value       = module.vpc.public_subnets
  description = "A list of IDs for the public subnets in the VPC"
}

output "ec2_instance_id" {
  value       = module.ec2-instances.id
  description = "The ID of the EC2 instance"
}