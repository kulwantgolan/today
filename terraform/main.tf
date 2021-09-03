provider "aws" {
    region = "ap-southeast-2"
    #admin user - via env variable or .aws config file
}



# https://www.terraform.io/docs/language/values/outputs.html
# output values
/*
terraform state list
terraform state show <list-item>


output "dev-vpc-id" {
    value = aws_vpc.myapp-vpc.id
}

output "dev-vpcsubnet-id" {
    value = aws_subnet.myapp-subnet-1.id
}

*/



# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# Create VPC, subnet, igw, route table
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

# https://www.terraform.io/docs/language/modules/syntax.html
module "myapp-subnet" {
  source = "./modules/subnet"

 subnet_cidr_block = var.subnet_cidr_block
 avail_zone = var.avail_zone    #based on region
 env_prefix = var.env_prefix
 vpc_id = aws_vpc.myapp-vpc.id
 default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

/*
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#Create RT and also RT association
resource "aws_route_table" "myapp-router-table" {
    vpc_id = aws_vpc.myapp-vpc.id

    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id
    }

    tags = {
        Name = "${var.env_prefix}-rtb"
    }
}
*/


module "myapp-server" {

  source = "./modules/webserver"
 
 vpc_id = aws_vpc.myapp-vpc.id
 my_ip = var.my_ip
 env_prefix = var.env_prefix
 image_name = var.image_name
 instance_type = var.instance_type
 subnet_id = module.myapp-subnet.subnet.id      # from other(subnet) module
 # default_sg_id = module.myapp-server.default-sg.id       # from the module being called (this module)
 avail_zone = var.avail_zone
 public_key_location = var.public_key_location

}
/*
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-router-table.id
}
*/



# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
/*
resource "aws_security_group" "myapp-sg" {
  name        = "myapp-sg"
  description = "Allow SSH/TLS inbound traffic"
  vpc_id      = aws_vpc.myapp-vpc.id

    ingress {
        description      = "SSH from VPC"
        from_port        = 22
        to_port          = 22  #Defining a range of ports
        protocol         = "tcp"
        cidr_blocks      = [var.my_ip]  #who can ssh
    }

    ingress {
        description      = "TLS from VPC"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"] #any Source ip address
    }


    egress {
        from_port        = 0   #any port
        to_port          = 0
        protocol         = "-1" #any protocol
        cidr_blocks      = ["0.0.0.0/0"]      #any Destination ip address
        prefix_list_ids = []   #for allowing access to VPC endpoints
    }
  

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}
*/





