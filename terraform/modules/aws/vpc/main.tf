##
# This module manages a VPC for all of our infrastructure to exist in.
#
variable "name" { default = "vpc" }

output "id" { value = "${aws_vpc.main.id}" }
output "cidr" { value = "${aws_vpc.main.cidr_block}" }

resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "web-platform"
  }
}
