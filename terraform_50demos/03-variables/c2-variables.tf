variable "aws_region" {
  description = "Region in which AWS resource to be created"
  type        = string
  default     = "ap-southeast-2"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0210560cedcb09f07" #Amazon2 linux 
}

variable "ec2_instance_count" {
  description = "EC2 instance count"
  type        = number
  default     = 1
}