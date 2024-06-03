terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-east-1"
}
