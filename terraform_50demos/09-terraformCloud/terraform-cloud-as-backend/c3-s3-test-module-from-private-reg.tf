module "s3-website" {
  source = "app.terraform.io/hcta-demo1x/s3-website/aws"
  # registry.terraform.io - public registry HOSTNAME
  # app.terraform.io - terraform CLOUD private HOSTNAME
  #### HOSTNAME/Organisation/modulename/provider -
  ### github REPOname for module (imported in Organisation registry/module): terraform-PROVIDER-modulename
  version = "1.0.1"

  # insert required variables here
  bucket_name = var.my_s3_bucket
  tags        = var.my_s3_tags
}

