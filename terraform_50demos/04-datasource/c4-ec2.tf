
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami   <<<<
# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html  <filter>

data "aws_ami" "amzlinux" {

  most_recent      = true    #or use name_regex(but performance is impacted)
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

    filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

################################################
output "ami_name" {
  description = "AMI Name USED"
  value = data.aws_ami.amzlinux.name
}
output "ami_id" {
  description = "AMI ID USED"
  value = data.aws_ami.amzlinux.id
}
################################################

resource "aws_instance" "my-ec2-vm" {
  ami   = data.aws_ami.amzlinux.id        #data source using
  instance_type = "t2.micro"
}
