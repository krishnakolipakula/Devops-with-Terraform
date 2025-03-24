# outputs.tf - Output definitions for the multi-region EC2 deployment

# Outputs for us-east-1 region
output "east1_instance_ids" {
  description = "IDs of the instances in us-east-1"
  value       = aws_instance.east1_instances[*].id
}

output "east1_public_ips" {
  description = "Public IPs of the instances in us-east-1"
  value       = aws_instance.east1_instances[*].public_ip
}

# Outputs for us-west-1 region
output "west1_instance_ids" {
  description = "IDs of the instances in us-west-1"
  value       = aws_instance.west1_instances[*].id
}

output "west1_public_ips" {
  description = "Public IPs of the instances in us-west-1"
  value       = aws_instance.west1_instances[*].public_ip
}

# Outputs for us-west-2 region
output "west2_instance_ids" {
  description = "IDs of the instances in us-west-2"
  value       = aws_instance.west2_instances[*].id
}

output "west2_public_ips" {
  description = "Public IPs of the instances in us-west-2"
  value       = aws_instance.west2_instances[*].public_ip
}