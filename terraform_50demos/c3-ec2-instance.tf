# Resource-6: Create EC2 Instance - AMI, KEY, SUBNET, SG, initial script

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my-ec2-vm" {
  ami           = "ami-0210560cedcb09f07" # ap-southeast-2
  instance_type = "t2.micro"
  key_name      = "terraform-key"

  subnet_id = aws_subnet.vpc-dev-public-subnet-1.id
  # If you are creating Instances in a VPC NOTE: security_groups is - (Optional, EC2-Classic and default VPC only)
  vpc_security_group_ids = [aws_security_group.vpc-dev-sg.id]

  # https://www.terraform.io/docs/language/functions/file.html
  # user_data = file("apache-install.sh")
  user_data = <<-EOF
        #! /bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo service httpd start  
        sudo systemctl enable httpd
        echo "<h1>Welcome to Apache Server ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
   EOF
}