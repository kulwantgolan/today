
# EC2 using both the SGs (SG ids specified) -> DEPLOYED IN with one of 3 default subnets of default VPC

resource "aws_instance" "my-ec2-vm" {
  ami   = var.ec2_ami_id
  # count = var.ec2_instance_count
  # instance_type = var.ec2_instance_type         

  # vaiable.tf - declare var and use default value: ec2_instance_count { default = 2 }  |  ec2_instance_type { default = t2.micro }
  # Value prompted in CLI if default not provided 
  # IN CLI, -var="name=value" to overwrite default
  # ENV variable , TF_var_name overwrite var/default : TF_VAR_ec2_instance_count = 3 TF_VAR_ec2_instance_type = t3.micro
  # USE terraform.tfvars file, - autoload variables defined in it - ec2_instance_count = 5 ec2_instance_type = t3.small

  # USE filename.tfvars file, In CLI -var-file="file.tfvars"
  # filename.auto.tfvars - also autoload variables
  # List (or tuple)(sequence of value) and Maps (object) (group of values idenfied by named labels) - in input variables
  # Custom Validation rules in Variables (length of ec2_ami_id > 4 AND start with ami-)
  # Protect Sensitive input variables - RDS DB with DB Username and Password
  # # Redact from Command output in log files and error when exposed (e.g. output) BUT not from state file

  # https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence
  # Loads in following order: 
  #  1 Env variables 
  #  2 terrafarm.tfvars
  #  3 terrafarm.tfvars.json
  #  4 *.auto.tfvars/ *.auto.tfvars.json (lexical order of filename)
  #  5 -var and -var-file
  # If multiple sources of variable - terraform uses last value it finds

  # # instance_type = var.ec2_instance_type[0]  #list
  instance_type = var.ec2_instance_type["big-apps"] #Map
  # # tags = var.ec2_instance_tags  # Map
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]

  user_data = file("apache-install.sh")

  # tags = {
  #   "Name" = "myec2vm"
  # }


}
