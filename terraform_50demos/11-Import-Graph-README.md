## State import

* import existing infra
* transition to terraform mgmt
* terraform.io/docs/cli/import/index/html
* devepment effort will be there - still need to write tf file - even though state is imported

## import cmd
* Demo1: create Ec2 manually on AWS cloud - import state to terraform
* Demo2: Create S3 bucket manually on AWS cloud - import sate to terraform

EC2: instance-id is unique identifier
```
c1.tf - provider
c2-ec2.tf
resource "aws_instance" "myec2" {
}

terraform init
terraform import    aws_instance.myec2     instance_id_from_aws
=> terraform.tfstate file created
```
* NOW write terraform conf file to match state file and use arguments reference and terraform plan
  * ami, instance_type, avilability_zone, key_name
  * terraform plan : know what is still missing (tags) : make sure no changes
  * try changing instance_type and verify that terraform apply works


S3: bucket_name is unique identifier
```
c1.tf - provider
c2-ec2.tf
resource "aws_s3_bucket" "mybucket" {
}
terraform init
terraform import    aws_s3_bucket.mybucket     bucket_name_from_aws
=> terraform.tfstate file created
```
* NOW write terraform conf file to match state file and use arguments reference and terraform plan
  * Note in state file: acl : null , force_destroy : null
  * bucket, acl = "private" (default value) ,force_destory = false  (default value) 
    * terraform apply: to apply it to state file 
  * terraform plan : know what is still missing (tags) : make sure no changes
  * try changing instance_type and verify that terraform apply works

## Terraform graph
* tf / plan : visual representation
* output in DOT format

```
terraform init
terraform graph > dot1

```
READ online: Graphviz online / edotor-online
READ offline:
* Graphviz is unstable on MacOS and need xcode (need disk space)
* so do in windows 2019 Base- AWS - t2.large, 3389 allow SG
* RDP client, get pwd using private key file for VM
* microsoft remote desktop:  adminstrato@password
* Server mgr > IE enhanced security conf : off
* IE (use no reccommeded setting )to get chrome
* terraform download
* c:\terraforms-bins\terraform.exe
* env variables: path : edit: add new:  c:\terraforms-bins
* terraform version
* graphviz.org : Download : windows 
* close and reopen cmd
* c:\graphviz-demo : terraform-manifest
* cmd: c:\graphviz-demo\terraform-manifest
* terraform init
* terraform graph | dot -Tsvg > graph.svg




