terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address = "https://vault.example.com:8200"
  token  = "your_vault_token" 
}

data "vault_generic_secret" "aws_credentials" {
  path = "secret/data/aws_creds"
}

provider "aws" {
  region = "us-east-1"
  access_key = data.vault_generic_secret.aws_credentials.data.access_key
  secret_key = data.vault_generic_secret.aws_credentials.data.secret_key
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c9483720cff7227e" # Replace with your desired AMI
  instance_type = "t2.micro"
  # ... other configuration ...
}
