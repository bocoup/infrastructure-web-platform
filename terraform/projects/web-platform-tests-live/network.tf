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

# WPT may update the set of required subdomains at any time. A "wildcard" CNAME
# record allows the deployment to accommodate such dynamism without further
# modification to the DNS configuration.
resource "aws_route53_record" "web_platform_tests_live_CNAME_wildcard-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "*"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

# WPT endorses the use of the subdomain `nonexistent` for tests which require a
# non-existent host. An explicit CNAME record overrides the "wildcard" record
# defined above in order to ensure that requests to this particular subdomain
# do not resolve.
resource "aws_route53_record" "web_platform_tests_live_CNAME_nonexistent-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "nonexistent"
  ttl = "1"
  records = ["0.0.0.0"]
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

# WPT may update the set of required subdomains at any time. A "wildcard" CNAME
# record allows the deployment to accommodate such dynamism without further
# modification to the DNS configuration.
resource "aws_route53_record" "not_web_platform_tests_live_CNAME_wildcard-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "*"
  ttl = "1"
  records = ["not-web-platform-tests.live"]
}

# WPT endorses the use of the subdomain `nonexistent` for tests which require a
# non-existent host. An explicit CNAME record overrides the "wildcard" record
# defined above in order to ensure that requests to this particular subdomain
# do not resolve.
resource "aws_route53_record" "web_platform_tests_live_CNAME_nonexistent-not-web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "nonexistent"
  ttl = "1"
  records = ["0.0.0.0"]
}

module "web_platform_tests_live_http_health_check" {
  source = "../../modules/aws/health_check"
  fqdn = "web-platform-tests.live"
  type = "HTTP"
  port = "80"

  # The WPT server log entries do not designate the protocol of requests, so
  # this information is included in the path of the health check.
  #
  # https://github.com/web-platform-tests/wpt/pull/13632
  resource_path = "/?aws-health-check-http"

  measure_latency = true

  # Health Checks
  # this sns_arn resource was created manually in aws sns console
  # because it cannot be done via terraform. it sends messages to
  # infrastructure+web-platform@bocoup.com
  alert_sns_arn = "arn:aws:sns:us-east-1:682416359150:web-platform-domains-health-check"
}

module "web_platform_tests_live_https_health_check" {
  source = "../../modules/aws/health_check"
  fqdn = "web-platform-tests.live"
  type = "HTTPS"
  port = "443"

  # The WPT server log entries do not designate the protocol of requests, so
  # this information is included in the path of the health check.
  #
  # https://github.com/web-platform-tests/wpt/pull/13632
  resource_path = "/?aws-health-check-https"

  measure_latency = true

  # Health Checks
  # this sns_arn resource was created manually in aws sns console
  # because it cannot be done via terraform. it sends messages to
  # infrastructure+web-platform@bocoup.com
  alert_sns_arn = "arn:aws:sns:us-east-1:682416359150:web-platform-domains-health-check"
}
