# Create re-usable module for
## Create S3 Bucket
## Create Public RO policy for the bucket
 
# Access: https://mybucket-1046x.s3.ap-southeast-2.amazonaws.com/index.html
## bucket name: mybucket-1046x
## region: ap-southeast-2
## file in bucket: index.html



################ variables

variable "bucket_name" {
    description = "Name of the S3 bucket"
    type = string
  
}

variable "tags" {
    description = "Tags to set on the bucket"
    type = map(string)
    default = {}
  
}

################ Resource (main)

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl = "public-read"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": [
              "s3:GetObject"
          ],
          "Resource": [
              "arn:aws:s3:::${var.bucket_name}/*"
          ]
      }
  ]
}

  EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = var.tags
  force_destroy = true  # terraform destroy will destoy it (even if bucket is not empty)
}

################ output

output "arn" {
  description = "ARN"
  value = aws_s3_bucket.s3_bucket.arn
}

output "name" {
  value = aws_s3_bucket.s3_bucket.id
}

output "domain" {
  value = aws_s3_bucket.s3_bucket.website_domain
}

output "endpoint" {
  value = aws_s3_bucket.s3_bucket.website_endpoint
}

### terraform.tfvars

### upload the file index.html manually