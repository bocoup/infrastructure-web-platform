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
    "10.100.3.0/24",
    "10.100.4.0/24",
    "10.100.5.0/24"
  ]
}

##
# Get all availability zones from AWS for the region we are in
#
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "../../modules/aws/vpc"
  name = "${var.name}"
  cidr = "${var.vpc_cidr}"
}

module "subnet" {
  source = "../../modules/aws/subnet"
  name = "${var.name}"
  azs = "${data.aws_availability_zones.available.names}"
  vpc_id = "${module.vpc.id}"
  cidr_blocks = "${var.subnet_cidr_blocks}"
}


resource "aws_route53_zone" "web_platform_tests_live" {
  name = "web-platform-tests.live"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "web_platform_tests_live_A_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "A"
  name = "web-platform-tests.live"
  ttl = "1"
  records = ["${aws_instance.web_platform_tests_live.public_ip}"]
}

resource "aws_route53_record" "web_platform_tests_live_CNAME_www-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "web_platform_tests_live_CNAME_xn--lve-6lad-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "xn--lve-6lad"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "web_platform_tests_live_CNAME_www1-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www1"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "web_platform_tests_live_CNAME_www2-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www2"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "web_platform_tests_live_CNAME_xn--n8j6ds53lwwkrqhv28a-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "xn--n8j6ds53lwwkrqhv28a"
  ttl = "1"
  records = ["web-platform-tests.live"]
}


## alternate domain dns records
resource "aws_route53_zone" "not_web_platform_tests_live" {
  name = "not-web-platform-tests.live"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "not_web_platform_tests_live_A_not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "A"
  name = "not-web-platform-tests.live"
  ttl = "1"
  records = ["${aws_instance.web_platform_tests_live.public_ip}"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_www-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["not-web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_xn--lve-6lad-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "xn--lve-6lad"
  ttl = "1"
  records = ["not-web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_www1-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www1"
  ttl = "1"
  records = ["not-web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_www2-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www2"
  ttl = "1"
  records = ["not-web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_xn--n8j6ds53lwwkrqhv28a-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "xn--n8j6ds53lwwkrqhv28a"
  ttl = "1"
  records = ["not-web-platform-tests.live"]
}
