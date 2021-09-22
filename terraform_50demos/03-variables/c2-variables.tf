variable "aws_region" {
  description = "Region in which AWS resource to be created"
  type        = string
  default     = "ap-southeast-2"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0210560cedcb09f07" #Amazon2 linux 
  # Custom validation rules
  validation {
    condition     = length(var.ec2_ami_id) > 4 && substr(var.ec2_ami_id, 0, 4) == "ami-"
    error_message = "EC2 ami_id is invalid. Not Starting with ami- or longer than 4 characters."
  }
}

variable "ec2_instance_count" {
  description = "EC2 instance count"
  type        = number
  default     = 1
  sensitive = true
}

/*
# Assign when prompted using CLI
variable "ec2_instance_type" {
  description = "EC2 instance type"
  #type        = string
  #  default = "t2.micro"
  type = list(string)
  default = [ "t3.micro", "t3.small", "t3.large"]
}
*/

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = map(string)
  default = {
    "small-apps"  = "t3.micro"
    "medium-apps" = "t3.small"
    "big-apps"    = "t3.large"
  }
}

# MAP
variable "ec2_instance_tags" {
  description = "EC2 Tags"
  type        = map(string)
  default = {
    "Name" = "ec2-web"
    "Tier" = "web"
  }
}

# variable "db_username" {
#   description = "AWS RDS DB Admin Username"
#   type        = string
#   sensitive   = true
# }

# variable "db_password" {
#   description = "AWS RDS DB Admin Password"
#   type        = string
#   sensitive   = true
# }

variable "app_name" {
  description = "Applicatin Name"
  type = string
  
}

variable "environment_name" {
  description = "Environment name"
  type = string
  
}


