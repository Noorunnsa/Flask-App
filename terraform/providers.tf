#Configure the AWS Provider
provider "aws" {
  region = var.region
}

#Configure the S3 Backend and the Dynamodb table for state locking
terraform {
  backend "s3" {
    bucket         = "flaskapp-statefiles"
    key            = "statefiles/flaskapp.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
  }
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
