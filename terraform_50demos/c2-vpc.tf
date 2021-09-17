# Resources Block

# terraform-key key-pair is created in AWS - to use with EC2

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# Resource-1: Create VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16" #required
  tags = {
    "Name" = "vpc-dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# Resource-2: Create Subnets
resource "aws_subnet" "vpc-dev-public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2a" # optional
  map_public_ip_on_launch = true              #default is false
  tags = {
    Name = "vpc-dev-public-subnet-1"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# Resource-3: Internet Gateway - Attach to VPC
resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = aws_vpc.vpc-dev.id

  tags = {
    Name = "main"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# Resource-4: Create Route Table
resource "aws_route_table" "vpc-dev-public-route-table" {
  vpc_id = aws_vpc.vpc-dev.id

}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# Resource-4a: Create Route in Route Table for Internet Access - Default route to IGW
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = aws_route_table.vpc-dev-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"                      # Any traffic
  gateway_id             = aws_internet_gateway.vpc-dev-igw.id # Target 
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# Resource-4b: Associate the Route Table with the Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate" {
  route_table_id = aws_route_table.vpc-dev-public-route-table.id
  subnet_id      = aws_subnet.vpc-dev-public-subnet-1.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Resource-5: Create Security Group - With terraform define Allow all egress (GUI have it via default)
resource "aws_security_group" "vpc-dev-sg" {
  name        = "vpc-dev-default-sg"
  description = "Dev VPC Default Security Group"
  vpc_id      = aws_vpc.vpc-dev.id

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
    Name = "Allow_SSH_HTTP"
  }
}