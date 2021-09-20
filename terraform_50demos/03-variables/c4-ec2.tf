
# EC2 using both the SGs (SG ids specified) -> DEPLOYED IN with one of 3 default subnets of default VPC

resource "aws_instance" "my-ec2-vm" {
  ami           = var.ec2_ami_id
  count         = var.ec2_instance_count
  instance_type = var.ec2_instance_type           
  
  # vaiable.tf - declare var and use default value: ec2_instance_count { default = 2 }  |  ec2_instance_type { default = t2.micro }
  # Value prompted in CLI if default not provided 
  # IN CLI, -var="name=value" to overwrite default
  # ENV variable , TF_var_name overwrite var/default : TF_VAR_ec2_instance_count = 3 TF_VAR_ec2_instance_type = t3.micro
  # USE terraform.tfvars file, - autoload variables defined in it ec2_instance_count = 5 ec2_instance_type = t3.small
  # 



  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]

  user_data = <<-EOF
  #! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo service httpd start  
sudo systemctl enable httpd
echo "<h1>Welcome to Apache Server ! AWS Infra created using Terraform in ap-southeast-2 Region</h1>" > /var/www/html/index.html
EOF
  tags = {
    "Name" = "myec2vm"
  }

}
