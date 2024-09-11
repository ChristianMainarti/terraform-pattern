terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_acess_key
  secret_key = var.aws_secret_access_key
}

terraform {
  cloud {

    organization = "mainarti_dev"

    workspaces {
      name = "api_pattern"
    }
  }
}