# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Resource-5: Create Security Group - With terraform define Allow all egress (GUI have it via default)
resource "aws_security_group" "vpc-ssh-http-sg" {
  name        = "vpc-dev-${terraform.workspace}-sg"   #same resource in different workspace
  description = "Dev VPC Default Security Group"
 

  # https://www.terraform.io/docs/language/attr-as-blocks.html - info on using [] for ingress and egress
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    description = "Allow all IP and ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ALL
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Allow_SSH_HTTP-${terraform.workspace}"
  }
}