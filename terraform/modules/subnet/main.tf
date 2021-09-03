# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "myapp-igw" {
   vpc_id = var.vpc_id
    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
# Using existing default RT to configure routes (subnet association needs not to be defined as it happen by default)
resource "aws_default_route_table" "main-rtb" {
    #we are referencing existing RT and this don't need VPC ID (we know it and use it to get RT id)
    default_route_table_id = var.default_route_table_id  #replace as refrence to obj in root module
     
    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id   #not replace as it is in same module
    }

    tags = {
        Name = "${var.env_prefix}-main-rtb"
    }

}