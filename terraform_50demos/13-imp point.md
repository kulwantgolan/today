* naming scheme for provider plugins : terraform-provider-<NAME>_vX.Y.Z
* 
* public registry HOSTNAME: registry.terraform.io 
*
* terraform CLOUD private HOSTNAME: app.terraform.io
* Github REPOname for custom **module** - to import in Terraform Cloud **Organisation** Registry: terraform-**PROVIDER**-modulename
* HOSTNAME/Organisation/modulename/provider : Terraform Cloud module
*
* https://www.hashicorp.com/blog/automatic-installation-of-third-party-providers-with-terraform-0-13
 ```
 terraform {
    required_providers {
        # HashiCorp's dns provider
        hdns = {
            source = "hashicorp/dns"   
          
           # HOSTNAME/namespace/type : Public registry resouce type
           # If hostname is omitted, Terraform will use the Terraform Registry hostname : registry.terraform.io 
           # source is case-insensitive
             
        }
  ```
* CLI Configuration File (~/.terraformrc or  %APPDATA%\terraform.rc) or  env TF_CLI_CONFIG_FILE to specify it : it will apply across all working dir
 * use of a local directory as a shared plugin cache, which then allows each distinct plugin binary to be downloaded only once rather than for each working directory
 * plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"   # This directory must already exist 
 * or use TF_PLUGIN_CACHE_DIR

* EC2 Instance Profiles - STSAssumeRole Q78 - https://kichik.com/2020/09/08/how-does-ec2-instance-profile-work/
* Multiple instance of a module ? Q88
* 
 
 
 
 
 
 ```
 what it take to be a threat hunter? explore it.
 static and dynamic malicious code reverse engineering ?? binary instrumentation ??  quickly learn new analysis techniques?? improve our malware-analysis workflow.??
```
