
output "ec2_pubic_ip" {
  value = aws_instance.my-ec2-vm.public_ip #as count ot for_each is used
}

output "ec2_public_dns" {
  value = aws_instance.my-ec2-vm.public_dns #as count or for_each is used
}
