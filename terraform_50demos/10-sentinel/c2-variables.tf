# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "ap-southeast-2"

}

variable "my_s3_bucket" {
  description = "My S3 Bucket"
  type = string
  default = "mybucket-1051x"
}

variable "my_s3_tags" {
  description = "Tags for my S3 Bucket"
  type = map(string)
  default = {
    Terraform = "true"
    Environment = "dev"
    newtag1 = "tag1"
    newtag2 = "tag2"
  }
  
}