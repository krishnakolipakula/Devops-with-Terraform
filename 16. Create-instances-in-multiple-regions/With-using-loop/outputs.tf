# outputs.tf - Output definitions for the multi-region EC2 deployment

locals {
  # Group instances by region for outputs
  instances_by_region = {
    for region in keys(var.regions) : region => {
      ids        = [for k, v in aws_instance.instances : v.id if startswith(k, "${region}-")]
      public_ips = [for k, v in aws_instance.instances : v.public_ip if startswith(k, "${region}-")]
    }
  }
}

output "all_instance_ids" {
  description = "All instance IDs organized by region"
  value = {
    for region, data in local.instances_by_region : region => data.ids
  }
}

output "all_public_ips" {
  description = "All public IPs organized by region"
  value = {
    for region, data in local.instances_by_region : region => data.public_ips
  }
}

# Flattened outputs for backward compatibility
output "east1_instance_ids" {
  description = "IDs of the instances in us-east-1"
  value       = lookup(local.instances_by_region, "us-east-1", {ids = []}).ids
}

output "east1_public_ips" {
  description = "Public IPs of the instances in us-east-1"
  value       = lookup(local.instances_by_region, "us-east-1", {public_ips = []}).public_ips
}

output "west1_instance_ids" {
  description = "IDs of the instances in us-west-1"
  value       = lookup(local.instances_by_region, "us-west-1", {ids = []}).ids
}

output "west1_public_ips" {
  description = "Public IPs of the instances in us-west-1"
  value       = lookup(local.instances_by_region, "us-west-1", {public_ips = []}).public_ips
}

output "west2_instance_ids" {
  description = "IDs of the instances in us-west-2"
  value       = lookup(local.instances_by_region, "us-west-2", {ids = []}).ids
}

output "west2_public_ips" {
  description = "Public IPs of the instances in us-west-2"
  value       = lookup(local.instances_by_region, "us-west-2", {public_ips = []}).public_ips
}
