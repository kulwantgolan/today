# Create RDS

# Redact from Command output in log files and error when exposed BUT not from state files
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# resource "aws_db_instance" "db1" {
#   allocated_storage   = 5
#   engine              = "mysql"
#   instance_class      = "db.t2.micro"
#   name                = "mydb1"
#   username            = var.db_username
#   password            = var.db_password
#   skip_final_snapshot = true
# }