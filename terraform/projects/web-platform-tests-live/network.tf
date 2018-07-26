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
  records = ["${aws_eip.web_platform_tests_live.public_ip}"]
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
  records = ["${aws_eip.web_platform_tests_live.public_ip}"]
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

module "web_platform_tests_live_health_check" {
  source = "../../modules/aws/health_check"
  fqdn = "web-platform-tests.live"

  # Health Checks
  # this sns_arn resource was created manually in aws sns console
  # because it cannot be done via terraform. it sends messages to
  # infrastructure+web-platform@bocoup.com
  alert_sns_arn = "arn:aws:sns:us-east-1:682416359150:web-platform-domains-health-check"
}
