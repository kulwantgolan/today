# module "s3-website" {
#   source  = "app.terraform.io/hcta-demo1x/s3-website/aws"
#   # registry.terraform.io - public registry HOSTNAME
#   # app.terraform.io - terraform CLOUD private HOSTNAME
#   #### HOSTNAME/Organisation/modulename/provider -
#   ### github REPOname for module (imported in Organisation registry/module): terraform-PROVIDER-modulename
#   version = "1.0.1"

#   # insert required variables here
#   bucket_name = var.my_s3_bucket
#   tags = var.my_s3_tags
# }

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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
resource "aws_s3_bucket_object" "bucket" {
  acl = "public-read"
  bucket = aws_s3_bucket.s3_bucket.id  
  key    = "index.html"
  # source = "index.html"
  content = file("${path.module}/index.html")
  content_type = "text/html"
}
