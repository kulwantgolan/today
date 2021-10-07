# output "arn" {
#   description = "ARN"
#   value = module.s3-website.arn
# }

# output "name" {
#   value = module.s3-website.name
# }

# output "domain" {
#   value = module.s3-website.domain
# }

# output "endpoint" {
#   value = module.s3-website.endpoint
# }


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

output "endpoint_url" {
  value = "http://${aws_s3_bucket.s3_bucket.website_endpoint}/index.html"
}

### terraform.tfvars

### upload the file index.html manually