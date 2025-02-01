terraform {
  backend "s3" {
    bucket         = "flaskapp_statefiles"
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
