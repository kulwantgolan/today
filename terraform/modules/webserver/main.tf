# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
# Use default SG
resource "aws_security_group" "myapp-sg" {

    vpc_id = var.vpc_id
    name = "myapp-sg"

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
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}



resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id  #id of image, it can be diffeent in different region
  instance_type = var.instance_type
  
  # if we don't specify  VPC - it will be created in the default VPC in th region
  subnet_id =   var.subnet_id #module.myapp-subnet.subnet.id   # aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids =  [aws_security_group.myapp-sg.id] # [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone   #what is it is different from subnet_id provided?

  associate_public_ip_address = true

  #Key pairs to SSH - server-key-pair manually by UI
  # key_name = "server-key-pair"                   # hardcoded key-pair name as on aws
  key_name = aws_key_pair.ssh-key.key_name     # ObjectTYPE.ObjectName.AttributeName


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#user_data
# user_data will only get excuted once on intitial run
# ssh into machine and 
# docker ps

  user_data = file("./modules/webserver/entry-script.sh")
            /* 
            <<EOF
                #!/bin/bash
                sudo yum update -y && sudo yum install -y docker
                sudo systemctl start docker
                sudo usermod -aG docker ec2-user
                docker run -p 8080:80 nginx
            EOF
             */ 


  tags = {
    Name = "${var.env_prefix}-server"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
# automatic ssh key(server-key) creation or create 
# ssh-keygen - to create key-pair in ~/.ssh/id_rsa.pub
resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"  #name that will appear on AWS
  public_key = file(var.public_key_location)  #read from a file
}