resource "aws_eip" "production" {
  instance = "${aws_instance.build_master.id}"
  vpc      = true
}

resource "aws_security_group" "web" {
  name = "WPT Dashboard web server"
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
  name = "WPT Dashboard SSH server"
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

resource "aws_security_group" "buildbot" {
  name = "WPT Dashboard Buildbot communication"
  vpc_id = "${module.vpc.id}"
  ingress {
    from_port = 9989
    to_port = 9989
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

# > The first four IP addresses and the last IP address in each subnet CIDR
# > block are not available for you to use, and cannot be assigned to an
# > instance. For example, in a subnet with CIDR block 10.0.0.0/24, the following
# > five IP addresses are reserved: 
#
# https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html#VPCSubnet
resource "aws_instance" "build_master" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${element(module.subnet.ids, 0)}"
  private_ip = "10.101.23.10"
  vpc_security_group_ids = [
    "${aws_security_group.web.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.buildbot.id}",
  ]
  tags {
    "Name" = "${var.name}-build-master"
  }
}

variable "instance_ips" {
  default = {
    "0" = "10.101.23.100"
    "1" = "10.101.23.101"
  }
}

resource "aws_instance" "build_worker" {
  count = "2"

  ami = "${data.aws_ami.ubuntu.id}"
  associate_public_ip_address = false
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${element(module.subnet.ids, 0)}"
  private_ip = "${lookup(var.instance_ips, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.buildbot.id}",
  ]
  tags {
    "Name" = "${var.name}-build-worker-${count.index}"
  }
}
