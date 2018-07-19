resource "aws_instance" "production" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  subnet_id = "${element(module.subnet.ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.web_platform_test_live.id}",
  ]
  tags {
    "Name" = "${var.name}-production"
  }
}

resource "aws_eip" "production" {
  instance = "${aws_instance.production.id}"
  vpc      = true
}

resource "aws_security_group" "web_platform_test_live" {
  vpc_id = "${module.vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  records = ["${module.web_platform_tests_live.public_ip}"]
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
  name = "web-platform-tests.live"
  ttl = "1"
  records = ["${module.not_web_platform_tests_live.public_ip}"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_www-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_xn--lve-6lad-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "xn--lve-6lad"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_www1-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www1"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_www2-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "www2"
  ttl = "1"
  records = ["web-platform-tests.live"]
}

resource "aws_route53_record" "not_web_platform_tests_live_CNAME_xn--n8j6ds53lwwkrqhv28a-not_web_platform_tests_live" {
  zone_id = "${aws_route53_zone.not_web_platform_tests_live.zone_id}"
  type = "CNAME"
  name = "xn--n8j6ds53lwwkrqhv28a"
  ttl = "1"
  records = ["web-platform-tests.live"]
}
