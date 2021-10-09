* naming scheme for provider plugins : terraform-provider-<NAME>_vX.Y.Z
* 
* public registry HOSTNAME: registry.terraform.io 
*
* terraform CLOUD private HOSTNAME: app.terraform.io
* Github REPOname for custom **module** - to import in Terraform Cloud **Organisation** Registry: terraform-**PROVIDER**-modulename : terraform-<PROVIDER>-<NAME>
* HOSTNAME/Organisation/modulename/provider : (Terraform Cloud) private module
 * <HOSTNAME>/<NAMESPACE>/<NAME>/<PROVIDER>
* <NAMESPACE>/<NAME>/<PROVIDER> : refer registry module
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
 * Terraform v0.13 introduced the possibility for a module itself to use the for_each, count, and depends_on arguments
 * https://www.terraform.io/docs/language/modules/develop/providers.html
 *  a module with its own provider configurations is not compatible with for_each, count, or depends_on
 * To make a module compatible with the new features, you must remove all of the provider blocks from its definition.
* terraform state mv : command can also move items to a completely different state file, enabling efficient refactoring.  Q123
* 140 - wrap up tonight
* 185 - What are the types of Backend
 * standard - s3, etcd, k8s, pg : store stae and rely on local backend for performing operations
 * Enhanced - local and remote (std + remote operations): can store state and perform operations
* 188 - hot to switch from remote to local backend?
* primitive types : strin bool number 
* complex : group multiple values
  * collection: group similar: list set  map
  * structural: group potentially dissimilar values: tuple object
 * Q239 is good: You are configuring a remote backend in the terraform cloud. You didn’t create a workspace before you do terraform init. Does it work? Terraform Cloud will create it if necessary. If you opt to use a workspace that already exists, the workspace must not have any existing states.
 * Terraform CLI workspaces allow multiple state files to exist within a single directory, enabling you to use one configuration for multiple environments. Terraform Cloud workspaces contain everything needed to manage a given set of infrastructure, and function like separate working directories.
* Terraform Cloud’s **run triggers** allow you to link workspaces: like infrastructure pipelines as part of your overall deployment strategy
 
 
 
 
 
 
 
 ```
 what it take to be a threat hunter? explore it.
 static and dynamic malicious code reverse engineering ?? binary instrumentation ??  quickly learn new analysis techniques?? improve our malware-analysis workflow.??
```
