terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.50.0, < 4.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.60"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "azurerm" {
  features {}
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  tags = {
    Name        = "example-bucket"
    Environment = "Development"
  }
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"
  resource_group_name       = "example-resource-group"
  location                 = "East US"
  account_tier              = "Standard"
  account_replication_type = "LRS"
}

