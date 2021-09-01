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


variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable public_key_location {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# Create VPC, subnet, igw, route table
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

/*
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-router-table.id
}
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
# Using existing default RT to configure routes (subnet association needs not to be defined as it happen by default)
resource "aws_default_route_table" "main-rtb" {
    #we are referencing existing RT and this don't need VPC ID (we know it and use it to get RT id)
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
    
    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id
    }

    tags = {
        Name = "${var.env_prefix}-main-rtb"
    }

}

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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
# Use default SG
resource "aws_default_security_group" "default-sg" {

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
    Name = "${var.env_prefix}-default-sg"
  }

}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"] 

  # define criteria
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id  #id of image, it can be diffeent in different region
  instance_type = var.instance_type
  
  # if we don't specify  VPC - it will be created in the default VPC in th region
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone   #what is it is different from subnet_id provided?

  associate_public_ip_address = true

  #Key pairs to SSH - server-key-pair manually by UI
  key_name = "server-key-pair"                   # hardcoded key-pair name as on aws
  # key_name = aws_key_pair.ssh-key.key_name     # ObjectTYPE.ObjectName.AttributeName

/*
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#user_data
# user_data will only get excuted once on intitial run
  user_data = file("entry-script.sh")
            /* 
            <<EOF
                #!/bin/bash
                sudo yum update -y && sudo yum install -y docker
                sudo systemctl start docker
                sudo usermod -aG docker ec2-user
                docker run -p 8080:80 nginx
            EOF
             */ 
#ssh into machine and 
#docker ps
*/
  tags = {
    Name = "${var.env_prefix}-server"
  }
}

/*
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
# automatic ssh key(server-key) creation or create 
# ssh-keygen - to create key-pair in ~/.ssh/id_rsa.pub
resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)  #read from a file
}
*/

output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
}


