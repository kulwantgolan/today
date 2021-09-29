#### modules folder
######## aws-s3-static-website-bucket folder

######### variable in root module
variable "my_s3_bucket" {
  description = "Name of the S3 bucket passed to module"
  type        = string
  default     = "mybucket-1047x"
}

variable "my_s3_tags" {
  description = "Tags to set on the bucket"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }

}


######### call module
module "website_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket" #located in
  #  version = "value"

  #input parameters
  bucket_name = var.my_s3_bucket
  tags        = var.my_s3_tags
}



################ output

output "arn" {
  description = "ARN"
  value       = module.website_s3_bucket.arn

}

output "name" {
  value = module.website_s3_bucket.name
}

output "domain" {
  value = module.website_s3_bucket.domain
}

output "endpoint" {
  value = module.website_s3_bucket.endpoint
}