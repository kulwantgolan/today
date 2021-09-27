# Terraform Block
terraform {
  required_version = "~> 1.0.0" # which means 1.0.x
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  # Create bucket in AWS manually - Bucket version enabled - and a folder dev
  # terraform-kulwantgolan
  # ap-southeast-2
  # https://www.terraform.io/docs/language/settings/backends/s3.html
  backend "s3" {
    bucket = "terraform-kulwantgolan"
    key    = "dev/terraform.tfstate" #folder and file
    region = "ap-southeast-2"

  # State locking using DynamoDB
  # terraform-dev-state-table
  # LockID
  dynamodb_table = "terraform-dev-state-table"

#   A change in the backend configuration has been detected, which may require migrating existing
# │ state.
# │
# │ If you wish to attempt automatic migration of the state, use "terraform init -migrate-state".
# │ If you wish to store the current configuration with no changes to the state, use "terraform init
# │ -reconfigure".

# https://www.terraform.io/docs/cloud/migrate/index.html

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
