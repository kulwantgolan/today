provider "aws" {
    region = "ap-southeast-2"
    #admin user - via env variable
}

#init - install provider

#Global env variable - TF_VAR_
variable  avail_zone {}

variable "subnet_cidr_block" {
    description = "subnet cidr block"
    default = "10.0.10.0/24"
    type = string
}

variable "cidr_blocks" {
    description = "vpc or subnet cidr block"
    type = list(object({
        cidr_block = string,
        name = string
    }))
}

variable "environment" {
    description = "deployment environment"
    default = "development"
    type = string
}

#Create VPC and subnet
resource "aws_vpc" "development-vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
        Name = var.cidr_blocks[0].name
    }
}
resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = var.cidr_blocks[1].name
    }
}

#Create Subnet in the existing VPC
data "aws_vpc" "existing-vpc" {
    default = true
}
resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing-vpc.id
    cidr_block = "172.31.48.0/20"           #default VPC CIDR 172.31.0.0./16 + 3 subnets 172.31.0.0/20 172.31.16.0/20 172.31.32.0/20
    availability_zone = "ap-southeast-2a"
       tags = {
        Name = "subnet-default"
    }
}


output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}

output "dev-vpcsubnet-id" {
    value = aws_subnet.dev-subnet-1.id
}