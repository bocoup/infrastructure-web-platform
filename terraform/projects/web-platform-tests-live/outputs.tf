output "production_public_ip" {
  value = "${aws_instance.production.public_ip}"
}
