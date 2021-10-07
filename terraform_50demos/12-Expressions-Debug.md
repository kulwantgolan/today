## Terraform expressions

* refer/compute values in Terraform expression console

```
terrafrom console
```
### Terraform Functions

* numeric: min, max, pow(a,b)
* string: trim("target","char to remove"), trimprefix, trimsuffix, trimspace, join(seperator, list-with-seperator)
* collection: concat(list1 list2), contains(list, string), distinct(list), length(list|map|string), lookup(map,key,default)
* encoding: base64encode, base64decode, urlencode
* filesystem: file("${path.module}/showfilecontents.txt"), fileexists, templatefile(path,vars)

#### templatefile : read file and render its content as template

* means passing terraform vaiables to file ( that is read by the ec2 using user_data)

```
private-key/terraform-key.pem
c1.tf - provider
c2-variable.tf

variable "package_name" {
 type = strinf
 default = "httpd"
 }
 
c3-sg.tf
c4-ec2.tf
user_data = templatefile("user_data.tmpl", {package_name = var.package_name})

user_date.tmpl
sudo yum update -y
sudo yum install -y ${package_name}
sudo yum list installed | grep ${package_name} >> /tmp/package-installed-list.txt

c5-outputs.tf
output "security_group_ids {
value = concat([aws_security_group.vpc-ssh.id,aws_security_group.vpc-web.id])
}
```

### Dynamic expressions

* conditional expression

```
condition ? true : false
 var.a != "" ? var.a : "default-a"
```
* splat expression
  * can do it with for expression (but it will be complex)
  * list of ids
```
  var.list[*].id
  aws_instance.example[*].id    # earlier, aws_instance.example.*.id 
```


```
c1.tf
terraform
  required_provider
    aws
    random = {
      source = "hasicorp/random"\
      version = "~> 3.0"
    }

c2.tf
variable:
- avalilability_zones : list(string)
- high_availability : bool
- name : string ec2-user
- team : string


c3-var.tf
tags = local.common_tags
# you cannot define conditional expression

c4-ec2.tf
resource "random_id" "id" {
 byte_length = 8
}

locals { # block
 name = (var.name != "" var.name : random_id.id.hex}
 # in local block, you can define confitional expression
 owner = var.team
 common_tags = {  # argument of type map
  Owner = default
  Defaultuser = local.name
 }
}

# resource: ec2 dynamic expression
count = (var.high_availability == true ? 2 : 1)
availability_zone = var.availability_zones[count.index] #each ec2 in separate AZ
tags = local.common_tags

c7-elb.tf
resource "aws_elb" "elb" {
listener
health_check
....
instances = aws_instance.example[*].id   #because ec2 is having count # list

count = (var.high_availability == true ? 1 : 0)  # elb req when more than 1 ec2 instance
availability_zones = var.availability_zones    #subnet/AZ is required # AZ to serve
tags = local.common_tags
}
```
```
terraform init
terraform validate
terraform plan # HA = false and user = ec2-user
- count 0 for elb
- count 1 for ec2
terraform plan # HA = true and user = ""
- count 1 for elb
- count 2 for ec2
terraform apply
website accessible on elb address
```
### Dynamic blocks and locals

* repetable nested blocks in arguments
 * which do not accept expressions
* e.g. sg
 * ingress rule (port changing but block is same/repeating)

```
c1.tf 
c2-sg.tf

instead of following:

ingress {
description = "description 1"
from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
description = "description 2"
from_port = 8081
to_port = 8081
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


Use this:
# Define ports as list in locals block
locals {
 ports = [80,443,8080,8081,7080,7081]
}

#key: local.ports[0]
#value: 80

# ingress in  sg
dynamic "ingress" {

 for_each = local.ports    # key: local.ports[0] => ingress.key = 0
 
 content {
 description = "description ${ingress.key}" #ingress.key = 0 for first iteration
 from_port = ingress.value     #ingress.value = 80 for first iteration
 to_port = ingress.value
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
}

```

## Terraform debug

* env variable for debugging
 * TF_LOG : log level
  * TRACE
  * DEBUG
  * ERROR
  * WARN
  * INFO
 * TF_LOG_PATH : Where logs stored

```
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"  

OR add in .bashrc  #permanent env variables
OR PS> $profile
$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="terraform-trace.log" 

echo $env:TF_LOG
echo $env:TF_LOG_PATH
```
* Crash.log : debug logs : if terraform crashes (panic in go runtime) # terraform in written in go 
