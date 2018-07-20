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

