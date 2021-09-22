
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

output "ec2_instance_private_ip" {
    description = "EC2 Instance Private IP"
    value = aws_instance.my-ec2-vm.private_ip #Argument
}

output "ec2_instance_public_ip" {
    description = "EC2 Instance Public IP"
    value = aws_instance.my-ec2-vm.public_ip  #Attribute
}

output "ec2_security_groups" {
    description = "List EC2 Security Groups"
    value = aws_instance.my-ec2-vm.security_groups #Argument
}

output "ec2_publicdns" {   #DNS HOSTNAME 
    description = "EC2 Public DNS URL"
    value = "http://${aws_instance.my-ec2-vm.public_dns}" #Attribute
    sensitive = true # only redact from cli
    # terraform output ec2_publicdns :  will show value
    # terraform output : redact value. what really? yes
    # terraform output -json : will show value
}

output "ec2_instance_count" {
    value = var.ec2_instance_count
    sensitive = true
}


