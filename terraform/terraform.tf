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
# This is the network all of our services are hosted in. Each VPC is an isolated
# network for a project to live in.
#
variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

##
# This is all the networks we'll create subnets for. If we want to provide
# high availability for the services we host in this project, we would ideally
# put an instance in each one and load balance between them.
#
variable "subnet_cidr_blocks" {
  type = "list"
  default = [
    "10.100.0.0/24",
    "10.100.1.0/24",
    "10.100.2.0/24"
  ]
}

##
# Get all availability zones from AWS for the region we are in
#
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./modules/aws/vpc"
  name = "web-platform"
  cidr = "${var.vpc_cidr}"
}

module "subnet" {
  source = "./modules/aws/subnet"
  name = "web-platform"
  azs = "${data.aws_availability_zones.available.names}"
  vpc_id = "${module.vpc.id}"
  cidr_blocks = "${var.subnet_cidr_blocks}"
}


module "eshost" {
  source = "./projects/eshost"
}

module "pr-dashboard" {
  source = "./projects/pr-dashboard"
  vpc_id = "${module.vpc.id}"
  public_subnet_ids = "${module.subnet.ids}"
}

module "web-platform-test-live" {
  source = "./projects/web-platform-tests-live"
  vpc_id = "${module.vpc.id}"
  public_subnet_ids = "${module.subnet.ids}"
}
