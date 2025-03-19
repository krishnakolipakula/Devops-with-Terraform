# Define the Vault provider
provider "vault" {
  address = "https://vault.example.com"
}

# Define the AWS provider for creating resources
provider "aws" {
  region = "us-west-2"
}

# Create a Vault secret for database credentials
resource "vault_generic_secret" "database_creds" {
  path = "secret/data/database"

  data = {
    username = "db_user"
    password = "db_password"
  }
}

# Create an AWS IAM policy that allows access to the Vault secret
resource "aws_iam_policy" "vault_secret_access" {
  name        = "VaultSecretAccessPolicy"
  description = "Allow access to Vault secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = "arn:aws:secretsmanager:us-west-2:123456789012:secret:MySecret*"
      }
    ]
  })
}

# Attach the IAM policy to an IAM role
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = "example-role"
  policy_arn = aws_iam_policy.vault_secret_access.arn
}

# Use the Vault secret in an AWS resource (e.g., an EC2 instance)
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  # Use the secret from Vault for EC2 user data
  user_data = <<-EOF
              #!/bin/bash
              export DB_USERNAME=$(vault kv get -field=username secret/data/database)
              export DB_PASSWORD=$(vault kv get -field=password secret/data/database)
              EOF
}

