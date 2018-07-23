resource "aws_instance" "production" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  subnet_id = "${element(var.public_subnet_ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.web.id}",
  ]
  tags {
    "Name" = "${var.name}-production"
    "Foo" = "${var.name}-hello-world"
  }
#  iam_instance_profile = "${aws_iam_instance_profile.backup.name}"
}

resource "aws_eip" "production" {
  instance = "${aws_instance.production.id}"
  vpc      = true
}

resource "aws_instance" "staging" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  subnet_id = "${element(var.public_subnet_ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.web.id}",
  ]
  tags {
    "Name" = "${var.name}-staging"
  }
#  iam_instance_profile = "${aws_iam_instance_profile.backup.name}"
}

resource "aws_eip" "staging" {
  instance = "${aws_instance.staging.id}"
  vpc      = true
}

resource "aws_security_group" "web" {
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
