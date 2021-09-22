
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "mys3bucket" {
    bucket = local.bucket-name    #local used
    acl = "private"
    tags = {
        Name = local.bucket-name   #local used
        Environment = var.environment_name
    }
  
}


#Define locals

locals {
    bucket-name = "${var.app_name}-${var.environment_name}-bucket" 
}