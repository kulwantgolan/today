# Null Provider - has constructs that intentionally do nothing
# https://registry.terraform.io/providers/hashicorp/null/latest/docs



# # Null Resources - implements the standard resource lifecycle but takes no further action. - 
# - To do some job, which doesn't need to be inside real resource 
# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource

# https://www.terraform.io/docs/language/resources/provisioners/null_resource.html
# Provisioners Without a Resource is
# Defining Provisoners with in a null_resource

resource "null_resource" "sync_app1_static" {

    #https://www.terraform.io/docs/language/resources/provisioners/null_resource.html#triggers
    triggers = {
    # https://www.terraform.io/docs/language/functions/timestamp.html
    always-update = timestamp()  #cause this set of provisioners to re-run
    # update timestamp for this resource
    }

    depends_on = [ time_sleep.wait_90_sec ]

    connection {
    type        = "ssh"
    host        = aws_instance.my-ec2-vm.public_ip
    user        = "ec2-user"
    private_key = file("private-key/terraform-key.pem")

  }

    provisioner "file" { #copy folder
    source      = "apps/app1"
    destination = "/tmp"

  }

    provisioner "remote-exec" { #invoke a script on remote resource AFTER it is created
    inline = [
      "sudo cp -r /tmp/app1 /var/www/html"  
    ]
  }
  
}





# Time Provider: interact with time-based resources
# https://registry.terraform.io/providers/hashicorp/time/latest/docs
# https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep

resource "time_sleep" "wait_90_sec" {
    depends_on = [ aws_instance.my-ec2-vm ]
    create_duration = "90s"
}