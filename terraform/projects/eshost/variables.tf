##
# This tells Terraform where to persist the state of the infrastructure for
# this project. We use S3 so the state doesn't have to be manually checked
# into the repository.
#
terraform {
  backend "s3" {
    bucket = "web-platform-terraform"
    key = "eshost.tfstate"
    region = "us-east-1"
    profile = "web-platform"
  }
}
