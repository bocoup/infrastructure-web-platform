##
# Get all availability zones from AWS for the region we are in
#
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "../../modules/aws/vpc"
}

module "subnet" {
  source = "../../modules/aws/subnet"
  azs = "${data.aws_availability_zones.available.names}"
  vpc_id = "${module.vpc.id}"
}
