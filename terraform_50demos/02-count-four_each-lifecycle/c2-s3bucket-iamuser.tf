# resource "aws_instance" "web" {
#   ami           = "ami-0210560cedcb09f07" # ap-southeast-2
#   instance_type = "t2.micro"
#   count         = 5
#   tags = {
#     "Name" = "web-${count.index}"
#   }
# }



# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# resource "aws_s3_bucket" "mys3bucket" {

#   for_each = {
#     "dev"  = "my-dapp-bucket"
#     "qa"   = "my-qapp-bucket"
#     "stag" = "my-sapp-bucket"
#     "prod" = "my-papp-bucket"

#   }

#   bucket = "${each.key}-${each.value}"
#   acl    = "private"

#   tags = {
#     Name  = "${each.key}-${each.value}"
#     key   = each.key
#     value = each.value
#   }
# }

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user

# resource "aws_iam_user" "myuser" {

#   for_each = toset(["TJack", "TJames", "TDave"])
#   name     = each.key

#   tags = {
#     key   = each.key
#     value = each.value
#   }
# }

resource "aws_instance" "web" {
  ami           = "ami-0210560cedcb09f07" # ap-southeast-2
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-2a"

  tags = {
    "Name" = "web-3"
  }

  lifecycle {
    # create_before_destroy = true
    # prevent_destroy = true    #terraform destroy will not work
    ignore_changes = [
      tags
    ]
  }

}
