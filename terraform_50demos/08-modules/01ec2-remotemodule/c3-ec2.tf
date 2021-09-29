
# # Resource-6: Create EC2 Instance - AMI, KEY, SUBNET, SG, initial script

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# resource "aws_instance" "my-ec2-vm" {
#   ami           = "ami-0210560cedcb09f07" # ap-southeast-2
#   instance_type = "t2.micro"
#   key_name      = "terraform-key"


#   # If you are creating Instances in a VPC NOTE: security_groups is - (Optional, EC2-Classic and default VPC only)
#   vpc_security_group_ids = [aws_security_group.vpc-ssh-http-sg.id]

#   # https://www.terraform.io/docs/language/functions/file.html
#   # user_data = file("apache-install.sh")
#   user_data = <<-EOF
#         #! /bin/bash
#         sudo yum update -y
#         sudo yum install -y httpd
#         sudo service httpd start  
#         sudo systemctl enable httpd
#         echo "<h1>Welcome to Apache Server ! AWS Infra created using Terraform in ap-southeast-2 Region</h1>" > /var/www/html/index.html
#    EOF

#   tags = {
#     "Name" = "vm-${terraform.workspace}"
#   }

  
# }


# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest

module "ec2_instance" { 
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "instance-${each.key}"
 # instance_count = 2 # not working
 for_each = toset(["one", "two"])

  ami                    = "ami-0210560cedcb09f07"
  instance_type          = "t2.micro"
  key_name               = "terraform-key"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.vpc-ssh-http-sg.id]
 # subnet_id

   user_data = <<-EOF
        #! /bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo service httpd start  
        sudo systemctl enable httpd
        echo "<h1>Welcome to Apache Server ! AWS Infra created using Terraform in ap-southeast-2 Region</h1>" > /var/www/html/index.html
   EOF

  tags = {
    Name = "Module-Demo"
    Terraform   = "true"
  }
}

# taint a resource in module  
# terraform taint module.ec2_instance[\"one\"].aws_instance.this[0]


output "ec2_pubic_ip" {

  value = {
# https://www.terraform.io/docs/language/meta-arguments/for_each.html
    for k, v in module.ec2_instance : k => v.public_ip
  }
}

output "ec2_public_dns" {
  value = {
    for k, v in module.ec2_instance : k => v.public_dns
  }
}

output "ec2_private_dns" {
  value = {
    for k, v in module.ec2_instance : k => v.private_dns
  } 
}




