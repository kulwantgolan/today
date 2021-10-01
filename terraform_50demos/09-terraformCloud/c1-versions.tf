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
  region  = var.aws_region
  # profile = "default" - FOR CLOUD we are going to set access key accordingly
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


