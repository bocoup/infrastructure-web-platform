output "production_public_ip" {
  value = "${aws_instance.web_platform_tests_live.public_ip}"
}
