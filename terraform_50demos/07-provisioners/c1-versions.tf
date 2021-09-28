# Terraform Block
terraform {
  required_version = "~> 1.0.0" # which means 1.0.x
  required_providers {
    
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
# https://registry.terraform.io/providers/hashicorp/null/latest/docs
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
# https://registry.terraform.io/providers/hashicorp/time/latest/docs
    time = {
      source = "hashicorp/time"
      version = "0.7.2"
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

# IF using remote backend
#  backend "s3" {
#     bucket = "terraform-kulwantgolan"
#     key    = "workspaces/terraform.tfstate" #folder and file
#     region = "ap-southeast-2"
#   dynamodb_table = "terraform-dev-state-table"
#  }


