resource "aws_instance" "web_platform_tests_live" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  subnet_id = "${element(module.subnet.ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.web_platform_tests_live.id}",
  ]
  tags {
    "Name" = "${var.name}-production"
  }

  iam_instance_profile = "${aws_iam_instance_profile.web_platform_tests_live.id}"
}

resource "aws_eip" "web_platform_tests_live" {
  instance = "${aws_instance.web_platform_tests_live.id}"
  vpc      = true
}

resource "aws_security_group" "web_platform_tests_live" {
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

resource "aws_iam_instance_profile" "web_platform_tests_live" {
  name = "web_platform_tests_live"
  role = "${aws_iam_role.web_platform_tests_live.name}"
}

resource "aws_iam_role" "web_platform_tests_live" {
  name = "${var.key_name}"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {"AWS": "*"},
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "web_platform_tests_live" {
  name = "${var.key_name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "certbot-dns-route53 sample policy",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
                "arn:aws:route53:::hostedzone/${aws_route53_zone.web_platform_tests_live.zone_id}",
                "arn:aws:route53:::hostedzone/${aws_route53_zone.not_web_platform_tests_live.zone_id}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "web_platform_tests_live" {
  name = "${var.key_name}"
  roles = ["${aws_iam_role.web_platform_tests_live.name}"]
  policy_arn = "${aws_iam_policy.web_platform_tests_live.arn}"
}
