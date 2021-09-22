terraform {
    required_version = ">= 0.12"

# https://www.terraform.io/docs/language/settings/backends/s3.html
    backend "s3" {
        bucket = "myapp-bucket12"
        key = "myapp/state.tfstate"
        region = "ap-southeast-2"
    }
}

provider "aws" {
    region = "ap-southeast-2"
    #admin user - via env variable or .aws config file
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = { Name = "${var.env_prefix}-subnet-1" }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-server" {

  source = "./modules/webserver"
 
 vpc_id = module.vpc.vpc_id

 my_ip = var.my_ip
 env_prefix = var.env_prefix
 image_name = var.image_name
 instance_type = var.instance_type
 subnet_id = module.vpc.public_subnets[0] # module.myapp-subnet.subnet.id      # from other(subnet) module
 # default_sg_id = module.myapp-server.default-sg.id       # from the module being called (this module)
 avail_zone = var.avail_zone
 public_key_location = var.public_key_location

}






