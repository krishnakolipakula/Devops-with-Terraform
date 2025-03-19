# Terraform AWS Infrastructure Setup
This project contains a Terraform configuration that sets up a basic AWS infrastructure, including a VPC, subnets, route tables, security groups, and an EC2 instance.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Resources](#resources)
- [Pre-requisites](#pre-requisites)
- [Setup Instructions](#setup-instructions)

## Overview
This Terraform configuration provisions an AWS VPC environment with both public and private subnets, an EC2 instance with a web server, and an S3 bucket for static site storage. This is useful for deploying applications in a secure and scalable manner within AWS.

## Architecture
The Terraform configuration sets up the following architecture:
- A VPC with a CIDR block of `10.0.0.0/16`
- Private and public subnets spread across available availability zones (up to 3)
- Internet Gateway and NAT Gateway for routing traffic
- Route tables for public and private subnets
- An EC2 instance

## Resources
The following AWS resources are created:
- **VPC**: The primary VPC for networking
- **Subnets**: Private and public subnets
- **Route Tables**: Public and private route tables for managing routing
- **Internet Gateway**: Allows internet access for public resources
- **NAT Gateway**: Provides internet access to private subnets
- **EC2 Instance**: A t2.micro instance

## Pre-requisites
Before you begin, ensure you have the following installed:
- [Terraform](https://www.terraform.io/downloads.html) v1.9+ (preferably the latest version)
- An AWS account with access credentials (Use an IAM Identity Center sso account in your AWS credentials file)
- AWS CLI configured if you're importing resources or running commands manually

## Setup Instructions
### Step 1: Copy the .tf files to the root of your config
### Step 2: Run terraform init
### Step 3: Run terraform plan
### Step 4: Run terraform apply
### Step 5: Run terraform destroy