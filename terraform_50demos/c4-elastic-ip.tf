# Resource-7: Create Elastic IP - only if IGW is present/created (specify explicit dependency)

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "my-eip" {
  vpc        = true # EIP is in VPC
  instance   = aws_instance.my-ec2-vm.id
  depends_on = [aws_internet_gateway.vpc-dev-igw]
}