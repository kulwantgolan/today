* naming scheme for provider plugins : terraform-provider-<NAME>_vX.Y.Z
* 
* public registry HOSTNAME: registry.terraform.io 
* terraform CLOUD private HOSTNAME: app.terraform.io
*
* Github REPOname for custom module - to import in Terraform Cloud Organisation Registry: terraform-PROVIDER-modulename
*
* https://www.hashicorp.com/blog/automatic-installation-of-third-party-providers-with-terraform-0-13
 ```
 terraform {
    required_providers {
        # HashiCorp's dns provider
        hdns = {
            source = "hashicorp/dns"   
           # HOSTNAME/Organisation/modulename/provider : Terraform Cloud module
           # HOSTNAME/namespace/type : Public regitry resouce type
           # If hostname is omitted, Terraform will use the Terraform Registry hostname : registry.terraform.io 
           # source is case-insensitive
             
        }
  ```
  
  * CLI Configuration File (.terraformrc or terraform.rc): apply across all working dir
    * use of a local directory as a shared plugin cache, which then allows each distinct plugin binary to be downloaded only once rather than for each working directory
    * plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"   # This directory must already exist 
  * 

