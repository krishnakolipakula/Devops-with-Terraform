provider "aws" {
  region = "us-west-2"
}

# Define the Primary VPC
resource "aws_vpc" "primary_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "PrimaryVPC"
  }
}

# Define the Peered VPC
resource "aws_vpc" "peered_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "PeeredVPC"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peer_connection" {
  vpc_id        = aws_vpc.primary_vpc.id
  peer_vpc_id   = aws_vpc.peered_vpc.id
  peer_region   = "us-west-2"  # Modify if connecting across regions
  auto_accept   = true

  tags = {
    Name = "PrimaryToPeeredConnection"
  }
}

# Route for Primary VPC to access Peered VPC
resource "aws_route" "primary_to_peer" {
  route_table_id         = aws_vpc.primary_vpc.main_route_table_id
  destination_cidr_block = aws_vpc.peered_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}

# Route for Peered VPC to access Primary VPC
resource "aws_route" "peer_to_primary" {
  route_table_id         = aws_vpc.peered_vpc.main_route_table_id
  destination_cidr_block = aws_vpc.primary_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
}

# Define a Transit Gateway
resource "aws_ec2_transit_gateway" "transit_gateway" {
  description = "Example Transit Gateway"
  tags = {
    Name = "ExampleTransitGateway"
  }
}

# Attach Primary VPC to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "primary_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  vpc_id             = aws_vpc.primary_vpc.id
  subnet_ids         = aws_vpc.primary_vpc.private_subnet_ids

  tags = {
    Name = "PrimaryAttachment"
  }
}

# Attach Peered VPC to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "peered_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  vpc_id             = aws_vpc.peered_vpc.id
  subnet_ids         = aws_vpc.peered_vpc.private_subnet_ids

  tags = {
    Name = "PeeredAttachment"
  }
}

