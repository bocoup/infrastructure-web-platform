resource "aws_instance" "master" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name = "${var.key_name}"
  subnet_id = "${element(module.subnet.ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.web.id}",
    "${aws_security_group.ssh.id}",
  ]
  tags {
    "Name" = "${var.name}-production"
    "Foo" = "${var.name}-hello-world"
  }
}

resource "aws_eip" "production" {
  instance = "${aws_instance.master.id}"
  vpc      = true
}

resource "aws_instance" "worker-chrome-unstable" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name = "${var.key_name}"
  subnet_id = "${element(module.subnet.ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
  ]
  tags {
    "Name" = "${var.name}-staging"
  }
}

resource "aws_instance" "worker-firefox-unstable" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name = "${var.key_name}"
  subnet_id = "${element(module.subnet.ids, 0)}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
  ]
  tags {
    "Name" = "${var.name}-staging"
  }
}

resource "aws_security_group" "web" {
  vpc_id = "${module.vpc.id}"
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

resource "aws_security_group" "ssh" {
  vpc_id = "${module.vpc.id}"
  ingress {
    from_port = 22
    to_port = 22
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
