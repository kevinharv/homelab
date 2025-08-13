/*
    Provider configuration for AWS.

    REQUIRED VARS
    - aws_region
    - aws_access_key
    - aws_secret_key
*/

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}