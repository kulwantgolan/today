## Turn on trial plan for Sentinel 

* For "hcta-demo1x" Organisation, enable trial plan in settings > Plan (30-day trial) Trial Plan
* Plan are organisation specific
* Create CLI Driven workflow "sentinel-demo1"
    * Cost estimation and plicy checked (sentinel) feather
    * Update backend info   : need terraform init to update backend (ask to move state if exist, which needs to be removed after migrating - for issuing further terraform apply)
* Conf env variable
    * AwS credentials 

```terraform
terraform login
terraform init            # update remote backend
terraform plan            # cost estimation also provided
terraform apply -auto-approve
``` 

## Sentinel language
It is used for Poilcy decision
* Define / Review existing policy 
```
# what to import (/v2)
tfplan : access to plan file
tfconfig : access to tf file
tfstate : access to state file
tfrun : access to data associate with run in Terraform Cloud
```
* Managing policy - for  Organisations
* Enforcing policy checks on runs
* Mock data for pocily testing using "SENTINEL CLI"

file1.sentinel  : check terraform  version

file2.sentinel  : Restrict S3 bucket

* Download Sentinel Mock files after terraform plan
* Unzip it  "Sentinel Mocks" folder
* Can write [sentinel policy](https://docs.hashicorp.com/sentinel/writing) by reviewing mock information
* https://www.terraform.io/docs/cloud/sentinel/import/tfplan-v2.html
* https://www.terraform.io/docs/cloud/sentinel/import/tfplan-v2.html#the-resource_changes-collection
* https://www.terraform.io/docs/cloud/sentinel/import/tfplan-v2.html#change-representation
* filter plan, define checks, write rulles --> apply in main rule
* rule1: for all S3 bucket create should have required tag
* rule2: for all S3 buckets have allowd_acl = public-read
* main rule: rule1 and rule2 are present and true

sentinel.hcl
* What policies to include: 
    * source : file1.sentinel
    * enforcement_level : "soft-mandory"

#### Use Sentinel policy use pre-build (in 3rd Gen) 

## Lets do it...Practical 

* Create github terraform-sentinel-policies
* clone it
* copy file1.sentinel, file2.sentinel , sentinel.hcl into this folder
* git add .
* git commit -m "initial commit"
* git push
* Create Polict Set in Terraform Cloud
* Organisation - hcta-demo1x
* Settings>  trial plan enabled
* Settings> Policy sets -  Connect - OAuth - repo - use "terraform-sentinel-poicies"    
    *  Scope of Policy: on specific workspace - sentinel-demo1
* Change index.html little bit : effectively change aws_s3_bucket_object will change
* terraform plan : cost estimation is also there but Organisation policy check may fail if mistake in poicy
* Fix github repo for policies
* terraform plan
* terraform apply -auto-approve : if policy check is true(pass) then apply will execute
* If soft-mandorty policy fail (e.g. if required tags missing), provide you option to "override and continue" to apply changes
* If hard-mandorty policy fail, it fail

## Create Cost Control Policies

* Based on mock-tfplan-v2.sentinel : check instance_type
* Based on mock-tfrun.sentinel : variables, org, workspace, cost_estimate
    * cost_estimate > delta_montly_cost
* Let's write Policy "less-than-100-month.sentinel" : montly cost is less than $100

```
import "tfrun"
import "decimal" 

delta_monthly_cost = decimal.new(tfrun.cost_estimate.delta_monthly_cost)

main = rule {
    delta_monthly_cost.less_than(100)
}

```
* enforce this policy using "sentinel.hcl"
```
policy "less-than-100-month" {
  source  = "./less-than-100-month.sentinel"
  enforcement_level = "soft-mandatory"
}
```
* Copy this folder (containing file.sentinel and sentinel.hcl) into policy repo: terraform-sentinel-policies (which is already connected to policy set)
* git push

#### Create a new policy set

* Policy Sets > New > terraform-cost-control-policies .. 
    * Path: folder
    * Scope: on selected workspace: terraform-cloud-demo1 workspace
* terraform-cloud-demo1 - is connected to github repo terraform-cloud-demo1 (3 ec2 instances)
    * VCS integrated : auto run by changing repo / Queue plan via Terraform cloud GUI
* Change Terraform Cloud - change instance_type to t3.2xlarge - cost estimate > $100 (fail)

## Using Terraform Foundational Policies

* [Pre-built policies](https://github.com/hashicorp/terraform-foundational-policies-library)
* cis > aws/networking
* Center for Internet security Benchmarks 1.2.0 for AWS
    * 4.1: no 22 to  world
    * 4.2: no 3389 RDP from world
    * 4.3 : default SG restrict all trafic
    * source: directly from git repo
    * advisory level enforcement_level
*  add 4.1, 4.2, 4.3 - sentinel.hcl in new folder in terraform-sentinel-policies
#### Create policy set in cloud

* Settings > policy sets > connect new policy
* connect > github repo > terraform-sentinel-policies
    * name: cis policies
    * path: folder
    * apply to selecte workspace - terraform-cloud-demo1

* Queue plan

why 4.1 is failing. 
Answer:
```
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
```




 







