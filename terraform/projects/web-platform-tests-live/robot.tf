# This user is defined to allow the system running on Google Cloud Platform to
# modify DNS settings and thereby obtain TLS certificates via Let's Encrypt.
resource "aws_iam_user" "web-platform-tests-live" {
  name = "web-platform-tests-live"
}

resource "aws_iam_role" "web-platform-tests-live" {
  name = "web-platform-tests-live"
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

resource "aws_iam_policy" "web-platform-tests-live" {
  name = "web-platform-tests-live"
  description = "Rights for the system running on Google Cloud Platform"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:GetHostedZone",
        "route53:ListHostedZonesByName"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ChangeResourceRecordSets",
      "Resource": "arn:aws:route53:::hostedzone/${aws_route53_zone.web_platform_tests_live.zone_id}"
    },
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    }
  ]
}
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "web-platform-tests-live" {
  name = "web-platform-tests-live"
  role = "${aws_iam_role.web-platform-tests-live.name}"
}

resource "aws_iam_policy_attachment" "web-platform-tests-live" {
  name = "web-platform-tests-live"
  roles = ["${aws_iam_role.web-platform-tests-live.name}"]
  users = ["${aws_iam_user.web-platform-tests-live.name}"]
  policy_arn = "${aws_iam_policy.web-platform-tests-live.arn}"
}
