terraform {
  required_version = "=0.13.5"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "cloud_test"
}