# Cloud and github integration
* ## create a repo in github https://github.com/kulwantgolan/terraform-cloud-demo1.git
* ## Sign up for cloud app.terraform.io/signup/account
* ## Create Organisation - hcta-demo1x
* ## Create Workspace - terraform-cloud-demo1 -  
* ## IN THE BACKGROUND: Terraform workspace connect to git hub repo (Terraform Cloud registers webhooks with your VCS provider when you create a workspace)

* ## Create variables
* ## Conf  Env variable - AWS access key    https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables
* # RUN -> Plan and (decide) and apply

# ############### MODULE ############### 

* ## Private Regisrty - to host module in Terraform Cloud ---private to Organisation in Terraform Cloud
* ## create a repo in github https://github.com/kulwantgolan/terraform-orivatereg-aws-s3-website.git (in terraform-cloud-internal folder)
* ## create a new release tag 1.0.0 in repo
* ## main.tf input.tf output.tf LIC README --> in repo
### STEP1 : Connect to VSC Provider(Github) using oAuth App in Terraform Cloud
* #### Using github.com- OAUth
* #### ## On github register a oAuth app get ClientID
* #### (optional)  Most organizations will not need to add an SSH private key. However, if the organization repositories include Git submodules that can only be accessed via SSH, an SSH key can be added along with the OAuth credentials.

### STEP2 : Import Module
* #### check in code -> create release

### STEP3: Accessing private registry - create tf file(configuration files)
* #### Download module with terraform init
* #### Accessing module from private registry 
* #### Configure credentials in .terraform.rc OR terraform.rc in root module conf (HARDCODE) - ## Configure credentials (NOT HARDCODED) would be better?

credentials "app.terraform.io" {
    # valid user API token:
    token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
    # terraform login 

* #### Creates  C:\Users\support.SP\AppData\Roaming\terraform.d\credentials.tfrc.json
* #### Asked to login in Terraform Cloud - API token created (provide in Terraform CLI)
* #### terraform init - download module
  

# ############### Terraform Cloud as remote backend - to use Terraform CLI driven workflow

* #### Using CLI Driven workflow but using modules in Private registry
* #### Earlier, we used version control workflow - git checkout - terraform cloud run (plan and apply ) activates
* #### Create Workspace - CLI drive workflow - 
* #### conf in local - issue terraform commands locally - but it runs on terraform cloud
* #### Add backend block in terraform



# ############### Migrating State from local to Terraform Cloud backend
* aws configure
* terraform init
* terraform plan
* terraform apply : got local state



