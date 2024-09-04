terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

terraform { 
  cloud { 
    
    organization = "mainarti_dev" 

    workspaces { 
      name = "api_pattern" 
    } 
  } 
}