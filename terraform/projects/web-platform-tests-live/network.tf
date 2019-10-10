##
# Get all availability zones from AWS for the region we are in
#
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "../../modules/aws/vpc"
}


