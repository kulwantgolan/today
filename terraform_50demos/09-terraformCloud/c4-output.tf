output "arn" {
  description = "ARN"
  value = module.s3-website.arn
}

output "name" {
  value = module.s3-website.name
}

output "domain" {
  value = module.s3-website.domain
}

output "endpoint" {
  value = module.s3-website.endpoint
}