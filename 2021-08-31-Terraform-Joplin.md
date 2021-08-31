## 1. Terraform commands


- **init** : install provider
- **refresh** : query infra provider to get current *state*
- **plan**
- **apply**
- **destroy**


## 2. AWS Intro
- VPC Service per region (**spans all AZ** in the region) - VPC is a virtual repesentation of network infrastructure. IP range defined
- Subnets : **span individaul AZ** (AZ is datacenter)
- IGW - Connects VPC to internet
- Firewall configuation for VPC or individual instances
	- For VPC: Create NACL and SG per VPC
	- For Subnet: **Assign NACL** to Subnet/AZ
	- For individual instances (EC2):  **Assign SG** to EC2


## 3. Git - Add existing folder in Computer to existing repo in github
```
git init
git remote add remote https://github.com/kulwantgolan/today.git
git pull remote main

git checkout -b main  # Create a new branch main
git reset --hard HEAD^ # delete last commit
git checkout master # switch to master branch

#contents of .gitignore file - ignore all hidden files except .gitignore
.*
!/.gitignore

git rm -r --cached .    # .gitignore will only effect files that haven't been 'added' already. To make new .gitignore entries affect all files
git status
git add .
git status

git branch -D branch_name
```

HELP: https://lcolladotor.github.io/2020/03/18/you-just-committed-a-large-file-and-can-t-push-to-github/


## 4. VPC Defaults in AWS
- Route table - 
	- To route **traffic within VPC (local Target)** - Entry for I**P address range as applied to VPC**
	- Default GW: 
- Subnet or AZ in region ( 3 AZ in my region )
- Default NACL: open
- Default SG: Closed

