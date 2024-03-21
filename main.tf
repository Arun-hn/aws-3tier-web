# Configure Terraform Behaviors
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Configure the Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


# Retrieve your IPv4 IP address
data "http" "icanhazip" {
  url = "https://ipv4.icanhazip.com"
}

# Use your IPv4 IP address for security groups
locals {
  my_ip_address = chomp(data.http.icanhazip.body)
}


