resource "aws_instance" "my-ec2-vm-new" {
  ami   = "ami-0210560cedcb09f07"        
  instance_type = "t2.micro"
 vpc_security_group_ids = [ aws_security_group.vpc-ssh-web.id]
  # same tag was created manually 
  # terraform refresh
  # chnage desired chnage based on state file info
  tags = {
    "Name"  = "linux -demo"
    "target" = "Target-Test-1"
  }
}

resource "aws_security_group" "vpc-ssh-web" {
  name = "vpc-ssh"
    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0" ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0" ]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0" ]
  }
  
}

resource "aws_instance" "my-ec2-vm-new-demo-1" {
  ami   = "ami-0210560cedcb09f07"        
  instance_type = "t2.micro"
  tags = {
    "Name"  = "linux -demo-1"
  }
}

# Read binary file plan or state file
# terraform show 
# terraform show (state/plan)FILE

# terraform refresh  -- update state file
# DESIRED STATE -> .tf files
# CURRENT STATE -> Real Resources in cloud
# Execution Order(keep manual changes in AWS):  Refresh -> Plan -> (Make a decision) -> Apply

# terraform state 
# - list/show (list resources/ show a particular resource attributes)
# - mv # we used here to rename resource local name AND then decide (like edit local conf)
## 1. Do not terraform apply but use change conf file
# - rm  # want a resource not to be managed by terraform 
## 1.Let it RUN in cloud but NOT Managed by terraform <remove from state and then from conf> 
## 2.Create a new resource without deleting Other (non-managed terraform) <remove resource and terraform apply>
# - replace-provider  # same provide from different resource
## terraform state replace-provider  hashicorp/aws registry.acme.corp/acme/aws
# - pull/push

# terraform force-unlock  
## only the remote state can be unlocked using LOCK_UD
## local state files cannot be unlocked by another process

# terraform taint - force recreate resource on next terraform apply

# terraform plan -target (focus on only a subset of resources - and its dependent - like SG for ec2)
# terraform apply -target








