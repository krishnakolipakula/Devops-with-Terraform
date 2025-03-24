provider "aws" {
  region = "us-west-2"
}

# Create VPC for EKS Cluster
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "eks_subnet" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "eks_sg" {
  name        = "eks-security-group"
  vpc_id      = aws_vpc.eks_vpc.id
  description = "Allow all inbound and outbound traffic"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet.id]
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

# IAM Role for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# EKS Node Group with GPU Instances
resource "aws_eks_node_group" "gpu_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "gpu-node-group"
  node_role       = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.eks_subnet.id]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  instance_types = ["p3.2xlarge"] # GPU instances for ML workloads
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

