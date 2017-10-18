output "production_public_ip" {
  value = "${aws_instance.production.public_ip}"
}

output "staging_public_ip" {
  value = "${aws_instance.staging.public_ip}"
}
