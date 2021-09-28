
# Resource-6: Create EC2 Instance - AMI, KEY, SUBNET, SG, initial script

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my-ec2-vm" {
  ami           = "ami-0210560cedcb09f07" # ap-southeast-2
  instance_type = "t2.micro"
  key_name      = "terraform-key"


  # If you are creating Instances in a VPC NOTE: security_groups is - (Optional, EC2-Classic and default VPC only)
  vpc_security_group_ids = [aws_security_group.vpc-ssh-http-sg.id]

  # https://www.terraform.io/docs/language/functions/file.html
  # user_data = file("apache-install.sh")
  user_data = <<-EOF
        #! /bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo service httpd start  
        sudo systemctl enable httpd
        echo "<h1>Welcome to Apache Server ! AWS Infra created using Terraform in ap-southeast-2 Region</h1>" > /var/www/html/index.html
   EOF

  #count = terraform.workspace == "default" ? 2 : 1

  tags = {
    "Name" = "vm-${terraform.workspace}"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("private-key/terraform-key.pem")

  }

  provisioner "file" {
    source      = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"

  }

  provisioner "file" {
    content     = "ami used: ${self.ami}"
    destination = "/tmp/file.log"

  }



  provisioner "file" { #copy content of a folder
    source      = "apps/app2/"
    destination = "/tmp"

  }

  # ec2-user cannot acess /var/www/html folder - should fail
  provisioner "file" { 
    source      = "apps/file-copy.html"
    destination = "/var/www/html/file-copy.html"
    on_failure = continue #output of terraform apply will not show error (resource created but provisioner fail)

  }

/*
  provisioner "file" { 
    source      = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"
  }


  provisioner "remote-exec" { #invoke a script on remote resource AFTER it is created
    inline = [
       "sleep 120",  # wait till apache server is provisioned using user_data
      "sudo cp /tmp/file-copy.html /var/www/html"  
    ]
  }
  */

  provisioner "local-exec" { # invoke a process on machine running terraform AFTER REMOTE RESOURCES is created
    #creation time - output private ip into a file
    command = "echo ${aws_instance.my-ec2-vm.private_ip} >> private_ip.txt"
    working_dir = "local-exec-files"

  }

  provisioner "local-exec" { # invoke a process on machine running terraform AFTER REMOTE RESOURCES is created
    #destroy time - output destroy time into a file
    command = "echo Destroyed at `date` >> private_ip.txt"
    working_dir = "local-exec-files"
    when = destroy # works when terraform destroy command is used
  }
}


# If Provisioner fails
## Be default,
### terraform apply itself will fail (on_failure  = continue attribute can be used to chnage it)
### By defualt,  the resource creation will fail (+ taint resource if create_provisioner)









