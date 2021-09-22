# Terraform Block
terraform {
  required_version = "~> 1.0.0" # which means 1.0.x
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = "ap-southeast-2"
  profile = "default"
}
/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
%HOMEPATH%/.aws/credentials
*/
