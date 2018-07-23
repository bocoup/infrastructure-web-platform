##
# This is primarily used as a convience for tagging resources so operators who
# are looking at the web UI can easily see project delinations. It's also used
# as a prefix in places where the underlying cloud provider requires unique
# names for resources we'd otherwise like to name generically.
#
variable "name" {
  default = "web-platform-tests-live"
}

##
# The name of the master private key to use for all compute resources. This is
# generated once by hand in the AWS EC2 web UI.
#
variable "key_name" {
  default = "web-platform-tests-live"
}

##
# This tells Terraform how to authenticate for AWS resources. It expects
# an entry in ~/.aws/credentials with a matching profile. You can create
# this with `aws configure --profile web-platform`.
#
provider "aws" {
  profile = "web-platform"
  region = "us-east-1"
}

##
# This locates the AMI for the Ubuntu image we'd like to use on all of our VMs
# for this project.
#
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180617"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  # Canonical
  owners = ["099720109477"]
}
