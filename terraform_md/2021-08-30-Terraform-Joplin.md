
## Terraform on RHEL8


```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

#Verify Terraform exist
terraform -help

#Terrafoirm autocomplete
touch ~/.bashrc
terraform -install-autocomplete
```
